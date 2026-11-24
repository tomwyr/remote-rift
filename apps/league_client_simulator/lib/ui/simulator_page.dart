import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../i18n/strings.g.dart';
import '../simulation/simulator_queue.dart';
import '../simulation/simulator.dart';
import 'simulator_cubit.dart';
import 'simulator_labels.dart';
import 'simulator_state.dart';

class const SimulatorPage() extends StatelessWidget {
  static Widget builder() {
    return BlocProvider(
      create: (_) => SimulatorCubit(Simulator()),
      child: const SimulatorPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SimulatorCubit>();
    final isListening = context.select(
      (SimulatorCubit cubit) => cubit.state.connection is Listening,
    );

    return Lifecycle(
      onInit: cubit.initialize,
      child: Scaffold(
        appBar: AppBar(title: Text(t.appTitle)),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 730),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const _ConnectionCard(),
                if (isListening) ...[
                  const SizedBox(height: 16),
                  const _SessionCard(),
                  const SizedBox(height: 16),
                  const _ScenarioCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class const _ConnectionCard() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final connection = context.select((SimulatorCubit cubit) => cubit.state.connection);
    final cubit = context.read<SimulatorCubit>();

    return _Section(
      title: t.connection.title,
      children: switch (connection) {
        Initial() || Starting() => [
          const LinearProgressIndicator(),
          Text(t.connection.starting),
        ],
        StartFailed(:var failure) => [
          Text(failure.localizedDescription),
          OutlinedButton(onPressed: cubit.retryStartup, child: Text(t.connection.retry)),
        ],
        Listening(:var lockfilePath) => [
          Text(t.connection.instructions),
          SelectionArea(child: Text(lockfilePath)),
          OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: lockfilePath));
              if (!context.mounted) return;
              final messenger = ScaffoldMessenger.of(context);
              messenger.showSnackBar(SnackBar(content: Text(t.connection.copied)));
            },
            icon: const Icon(Icons.copy_outlined),
            label: Text(t.connection.copyPath),
          ),
        ],
      },
    );
  }
}

class const _SessionCard() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final (online, stage, queue, response, seconds) = context.select((SimulatorCubit cubit) {
      final session = cubit.state.session;
      final timeLeft = session.timeLeft;
      final seconds = timeLeft == null
          ? null
          : (timeLeft.inMicroseconds / Duration.microsecondsPerSecond).ceil();
      return (session.online, session.stage, session.queue, session.readyCheckResponse, seconds);
    });
    final theme = Theme.of(context);
    final detail = switch (response) {
      .accepted => t.session.readyAccepted,
      .declined => t.session.readyDeclined,
      .none => null,
    };

    return _Section(
      title: t.session.title,
      children: [
        Text(
          online ? stage.localizedName : t.session.standby,
          style: theme.textTheme.headlineSmall,
        ),
        if (queue != null) Text(queue.localizedName),
        if (online && stage == .home) Text(t.session.noQueue),
        if (detail != null) Text(detail),
        if (seconds != null) Text(t.session.countdown(seconds: seconds)),
        if (online) const _SessionActions(),
      ],
    );
  }
}

class const _SessionActions() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SimulatorCubit>();
    final (stage, response) = context.select((SimulatorCubit cubit) {
      final session = cubit.state.session;
      return (session.stage, session.readyCheckResponse);
    });
    final buttons = switch (stage) {
      .home => [
        for (var queue in SimulatorQueue.values)
          (queue.localizedName, () => cubit.createLobby(queue)),
      ],
      .lobby => [
        (t.actions.startSearch, cubit.startSearch),
        (t.actions.leaveLobby, cubit.leaveLobby),
      ],
      .searching => [
        (t.actions.findNow, () => cubit.advance(stage)),
        (t.actions.stopSearch, cubit.stopSearch),
      ],
      .readyCheck when response == .none => [
        (t.actions.accept, () => cubit.answerReadyCheck(.accepted)),
        (t.actions.decline, () => cubit.answerReadyCheck(.declined)),
      ],
      .inGame => [(t.actions.endGame, () => cubit.advance(stage))],
      _ => [(t.actions.skipPhase, () => cubit.advance(stage))],
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var (index, (label, action)) in buttons.indexed)
          if (index == 0)
            ElevatedButton(onPressed: action, child: Text(label))
          else
            OutlinedButton(onPressed: action, child: Text(label)),
      ],
    );
  }
}

class const _ScenarioCard() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SimulatorCubit>();
    final (online, declineNextMatch, inSession) = context.select((SimulatorCubit cubit) {
      final session = cubit.state.session;
      return (session.online, session.declineNextMatch, session.stage != .home);
    });

    return _Section(
      title: t.scenarios.title,
      children: [
        SwitchListTile(
          contentPadding: .zero,
          title: Text(t.scenarios.online),
          subtitle: Text(t.scenarios.onlineDescription),
          value: online,
          onChanged: cubit.setOnline,
        ),
        SwitchListTile(
          contentPadding: .zero,
          title: Text(t.scenarios.declineNextMatch),
          subtitle: Text(t.scenarios.declineNextMatchDescription),
          value: declineNextMatch,
          onChanged: online ? cubit.setDeclineNextMatch : null,
        ),
        TextButton(
          onPressed: online && inSession ? cubit.reset : null,
          child: Text(t.actions.resetSession),
        ),
      ],
    );
  }
}

class const _Section({
  required final String _title,
  required final List<Widget> _children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return Card(
      margin: .zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            AppEyebrow(label: _title, accent: colors.gold),
            ..._children,
          ],
        ),
      ),
    );
  }
}
