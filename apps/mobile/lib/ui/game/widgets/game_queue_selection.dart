import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../../../data/models.dart';
import '../../../i18n/strings.g.dart';
import '../game_cubit.dart';

class const GameQueueSelectionButton({
  super.key,
  required final bool loading,
  required final List<GameQueue> availableQueues,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return TextButton.icon(
      style: TextButton.styleFrom(
        minimumSize: const .new(0, 40),
        tapTargetSize: .shrinkWrap,
        padding: const .symmetric(horizontal: 10, vertical: 6),
        foregroundColor: colors.navy,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(10),
          side: .new(color: colors.navy.withValues(alpha: 0.45)),
        ),
      ),
      onPressed: !loading && availableQueues.isNotEmpty
          ? () => GameQueueSelectionModal.selectAndUpdateQueue(
              context,
              availableQueues: availableQueues,
            )
          : null,
      icon: const Icon(Icons.tune, size: 18),
      label: Text(t.gameQueue.selectButton),
    );
  }
}

class const GameQueueSelectionModal({
  super.key,
  required final List<GameQueue> availableQueues,
}) extends StatelessWidget {
  static Future<void> selectAndUpdateQueue(
    BuildContext context, {
    required List<GameQueue> availableQueues,
  }) async {
    final cubit = context.read<GameCubit>();
    final queue = await show(context, availableQueues: availableQueues);
    if (queue != null && context.mounted) {
      cubit.createLobby(queueId: queue.id);
    }
  }

  static Future<GameQueue?> show(
    BuildContext context, {
    required List<GameQueue> availableQueues,
  }) {
    final cubit = context.read<GameCubit>();

    final heightRatio = switch (MediaQuery.orientationOf(context)) {
      .portrait => 0.7,
      .landscape => 0.85,
    };
    final maxHeight = MediaQuery.sizeOf(context).height * heightRatio;

    return showModalBottomSheet<GameQueue>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: .new(maxHeight: maxHeight, minWidth: .infinity),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: GameQueueSelectionModal(availableQueues: availableQueues),
      ),
    );
  }

  void _selectAndPop(BuildContext context, GameQueue queue) {
    context.read<GameCubit>().createLobby(queueId: queue.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: ListView(
        padding: const .fromLTRB(20, 4, 20, 0),
        children: [
          const _QueueSelectionHeader(),
          const SizedBox(height: 12),

          for (var (index, (:title, :queues)) in _resolveData().indexed) ...[
            if (index > 0) const SizedBox(height: 12),
            _QueuesSection(
              title: title,
              queues: queues,
              onSelect: (queue) => _selectAndPop(context, queue),
            ),
          ],

          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  List<({String title, Iterable<GameQueue> queues})> _resolveData() {
    final aiQueues = availableQueues.where((queue) => queue.category == .ai);
    final pvpQueues = availableQueues
        .where((queue) => queue.category == .pvp)
        .groupedBy((queue) => queue.group)
        .mapValues(
          (queues) => queues.orderedBy((queue) => queue.enabled ? 0 : 1),
        )
        .records
        .orderedBy((item) => item.$1.orderRank);

    return [
      for (var (group, queues) in pvpQueues) (title: group.displayName, queues: queues),
      if (aiQueues.isNotEmpty) (title: t.gameQueue.selectionAiTitle, queues: aiQueues),
    ];
  }
}

class const _QueueSelectionHeader() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 14),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            t.home.gameModeLabel.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.remoteRiftTheme.colorScheme.gold,
              fontWeight: .w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            t.gameQueue.selectionTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class const _QueuesSection({
  required final String title,
  required final Iterable<GameQueue> queues,
  required final void Function(GameQueue queueId) onSelect,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const .only(bottom: 6),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: .w800,
              letterSpacing: 0.9,
            ),
          ),
        ),

        for (var queue in queues)
          Column(
            children: [
              ListTile(
                contentPadding: const .symmetric(horizontal: 14),
                enabled: queue.enabled,
                visualDensity: .standard,
                onTap: () => onSelect(queue),
                title: Text(queue.name),
                trailing: queue.enabled ? const Icon(Icons.chevron_right) : const Icon(Icons.block),
              ),
              if (queue != queues.last) const Divider(height: 1),
            ],
          ),
      ],
    );
  }
}
