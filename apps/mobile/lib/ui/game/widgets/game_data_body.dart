import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/layout.dart';
import '../game_cubit.dart';
import '../game_state.dart';

class const GameDataBody({
  super.key,
  final String? queueName,
  final Widget? queueNamePlaceholder,
  required final String title,
  required final String description,
  final Widget? child,
  final RiftStatusTone tone = .neutral,
  final IconData? icon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hasFailedAction = context.select((GameCubit cubit) {
      final state = cubit.state;
      return state is Data && state.failedAction != null;
    });
    var effectiveQueueName = queueName;
    // Use placeholder text only if no placeholder widget is provided.
    if (queueNamePlaceholder == null) {
      effectiveQueueName ??= t.gameQueue.unknownPlaceholder;
    }

    return Column(
      crossAxisAlignment: .start,
      spacing: 12,
      children: [
        BasicLayoutSection(
          label: t.home.gameModeLabel,
          title: effectiveQueueName,
          titlePlaceholder: queueNamePlaceholder,
        ),
        BasicLayoutSection(
          label: t.home.gameStateLabel,
          title: title,
          titleFontSize: .large,
          description: description,
          tone: tone,
          icon: icon,
        ),
        if (hasFailedAction) const _GameActionRecovery(),
        ?child,
      ],
    );
  }
}

class const _GameActionRecovery() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GameCubit>();
    final state = cubit.state;

    if (state is! Data || state.failedAction == null) {
      return const SizedBox.shrink();
    }

    return BasicLayoutSection(
      label: t.gameState.actionFailed,
      description: t.gameState.actionRecoveryDescription,
      tone: .warning,
      titlePlaceholder: state.canRetry
          ? Align(
              alignment: .centerLeft,
              child: TextButton(
                onPressed: cubit.retry,
                child: Text(t.championSelect.retry),
              ),
            )
          : null,
    );
  }
}
