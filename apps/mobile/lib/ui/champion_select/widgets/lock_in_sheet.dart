import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/events_listener.dart';
import '../champion_select_cubit.dart';
import '../champion_select_state.dart';

class const ChampionSelectLockInSheet({
  super.key,
  required final Champion champion,
}) extends StatelessWidget {
  static Future<void> show(BuildContext context, {required Champion champion}) async {
    final cubit = context.read<ChampionSelectCubit>();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ChampionSelectLockInSheet(champion: champion),
      ),
    );
  }

  void _onEvent(BuildContext context, ChampionSelectEvent event) {
    switch (event) {
      case .actionCompleted:
        break;
      case .lockedIn:
        Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ChampionSelectCubit>();
    final actionStatus = cubit.state.statusOf(.lockIn);

    return EventsListener(
      events: cubit.events,
      onEvent: _onEvent,
      child: Padding(
        padding: const .all(20),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            Text(
              t.championSelect.lockInTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(champion.name),
            const SizedBox(height: 8),
            Text(t.championSelect.lockInGuidance),
            if (actionStatus == .failed) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.error_outline),
                  const SizedBox(width: 8),
                  Expanded(child: Text(t.championSelect.actionFailed)),
                ],
              ),
            ],
            const SizedBox(height: 16),
            if (actionStatus == .submitting) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 12),
            ],
            ElevatedButton(
              onPressed: actionStatus == .submitting ? null : cubit.lockIn,
              child: Text(t.championSelect.lockInConfirm),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: actionStatus == .submitting ? null : () => Navigator.of(context).pop(),
              child: Text(t.championSelect.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
