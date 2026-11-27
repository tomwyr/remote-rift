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

const _contentWidth = 730.0;
const _pageInset = 20.0;
const _buttonMinimumSize = Size(0, 40);

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
    final theme = Theme.of(context);

    return Lifecycle(
      onInit: cubit.initialize,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 48,
          titleSpacing: 0,
          titleTextStyle: theme.textTheme.titleMedium,
          title: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _contentWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: _pageInset),
                child: Align(alignment: .centerLeft, child: Text(t.appTitle)),
              ),
            ),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _contentWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(_pageInset, 8, _pageInset, 20),
              children: [
                if (isListening) ...[
                  const _SessionCard(),
                  const SizedBox(height: 12),
                  const _ScenarioCard(),
                  const SizedBox(height: 12),
                ],
                const _ConnectionCard(),
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

    return switch (connection) {
      Initial() || Starting() => _Section(
        title: t.connection.title,
        children: [
          const LinearProgressIndicator(),
          Text(t.connection.starting),
        ],
      ),
      StartFailed(:var failure) => _Section(
        title: t.connection.title,
        children: [
          Text(failure.localizedDescription),
          OutlinedButton(onPressed: cubit.retryStartup, child: Text(t.connection.retry)),
        ],
      ),
      Listening(:var lockfilePath) => _ConnectionDetails(lockfilePath: lockfilePath),
    };
  }
}

class const _ConnectionDetails({
  required final String lockfilePath,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.remoteRiftTheme.colorScheme;
    final instructionsStyle = textTheme.bodyMedium?.copyWith(
      color: colors.navy.withValues(alpha: .72),
    );
    final instructions = t.connection.instructions(
      navigationPath: TextSpan(
        text: t.connection.navigationPath,
        style: TextStyle(color: colors.navy, fontWeight: .w600),
      ),
    );
    final codeStyle = textTheme.bodySmall?.copyWith(
      fontFamily: 'Menlo',
      fontFamilyFallback: const ['Consolas', 'monospace'],
    );

    return _Section(
      title: t.connection.title,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text.rich(instructions, style: instructionsStyle),
        ),
        SizedBox(
          width: .infinity,
          child: AppValueBox(child: SelectableText(lockfilePath, style: codeStyle)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: _buttonMinimumSize),
            onPressed: () => _copyPath(context),
            icon: const Icon(Icons.copy_outlined),
            label: Text(t.connection.copyPath),
          ),
        ),
      ],
    );
  }

  Future<void> _copyPath(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: lockfilePath));
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(content: Text(t.connection.copied)));
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
        Wrap(
          spacing: 12,
          runSpacing: 4,
          crossAxisAlignment: .center,
          children: [
            Text(
              online ? stage.localizedName : t.session.standby,
              style: theme.textTheme.headlineSmall,
            ),
            if (seconds != null)
              Text(t.session.countdown(seconds: seconds), style: theme.textTheme.titleSmall),
          ],
        ),
        if (queue != null) Text(queue.localizedName),
        if (online && stage == .home) Text(t.session.noQueue),
        if (detail != null) Text(detail),
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
    final primaryStyle = ElevatedButton.styleFrom(minimumSize: _buttonMinimumSize);
    final secondaryStyle = OutlinedButton.styleFrom(minimumSize: _buttonMinimumSize);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var (index, (label, action)) in buttons.indexed)
          if (index == 0)
            ElevatedButton(style: primaryStyle, onPressed: action, child: Text(label))
          else
            OutlinedButton(style: secondaryStyle, onPressed: action, child: Text(label)),
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
    final theme = Theme.of(context);
    final tileTheme = ListTileTheme.of(context).copyWith(
      titleTextStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: .w600),
      subtitleTextStyle: theme.textTheme.bodySmall,
      contentPadding: .zero,
      visualDensity: .compact,
      minVerticalPadding: 4,
      minTileHeight: 56,
    );

    return _Section(
      title: t.scenarios.title,
      children: [
        ListTileTheme(
          data: tileTheme,
          child: Column(
            children: [
              _ScenarioSwitchTile(
                title: t.scenarios.online,
                description: t.scenarios.onlineDescription,
                value: online,
                onChanged: cubit.setOnline,
              ),
              _ScenarioSwitchTile(
                title: t.scenarios.declineNextMatch,
                description: t.scenarios.declineNextMatchDescription,
                value: declineNextMatch,
                onChanged: online ? cubit.setDeclineNextMatch : null,
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: online && inSession ? cubit.reset : null,
          child: Text(t.actions.resetSession),
        ),
      ],
    );
  }
}

class const _ScenarioSwitchTile({
  required final String _title,
  required final String _description,
  required final bool _value,
  required final ValueChanged<bool>? _onChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final onChanged = _onChanged;

    return ListTile(
      title: Text(_title),
      subtitle: Text(_description),
      trailing: AppSwitch(value: _value, onChanged: onChanged),
      enabled: onChanged != null,
      onTap: onChanged == null ? null : () => onChanged(!_value),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            AppEyebrow(label: _title, accent: colors.gold),
            ..._children,
          ],
        ),
      ),
    );
  }
}
