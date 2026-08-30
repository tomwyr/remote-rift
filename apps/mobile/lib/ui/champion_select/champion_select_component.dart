import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../../data/models.dart';
import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../common/duration.dart';
import '../game/widgets/game_data_body.dart';
import '../widgets/layout.dart';
import '../widgets/time_countdown.dart';
import 'champion_select_cubit.dart';
import 'widgets/lock_in_sheet.dart';
import 'widgets/picker_sheet.dart';

class const ChampionSelectComponent({
  super.key,
  required final String? queueName,
}) extends StatelessWidget {
  static Widget builder({
    required String? queueName,
    required ChampionSelect championSelect,
  }) {
    return BlocProvider(
      create: (context) => Dependencies.championSelectCubit(
        context,
        championSelect: championSelect,
      ),
      child: Builder(
        builder: (context) {
          context.read<ChampionSelectCubit>().updateChampionSelect(championSelect);
          return ChampionSelectComponent(queueName: queueName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ChampionSelectCubit>();
    final championSelect = cubit.state.championSelect;
    final champion = championSelect.champion;
    final availability = championSelect.actionAvailability;
    final actionStatus = cubit.state.statusOf(.lockIn);

    return Lifecycle(
      onInit: cubit.loadCatalog,
      child: BasicLayout(
        action: availability.lockInChampion && champion != null
            ? BasicLayoutAction(
                label: t.championSelect.lockInAction,
                onPressed: actionStatus == .submitting
                    ? null
                    : () => ChampionSelectLockInSheet.show(context, champion: champion),
              )
            : null,
        body: GameDataBody(
          queueName: queueName,
          title: t.championSelect.title,
          description: t.championSelect.description,
          tone: .active,
          icon: Icons.shield_outlined,
          child: _BodyContent(),
        ),
      ),
    );
  }
}

class const _BodyContent() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final championSelect = context.watch<ChampionSelectCubit>().state.championSelect;

    return Column(
      crossAxisAlignment: .stretch,
      spacing: 12,
      children: [
        BasicLayoutSection(
          label: t.championSelect.phaseLabel,
          title: championSelect.phase.displayName,
        ),
        _ChampionSelectCountdown(timeLeft: championSelect.timeLeft),

        _ChampionCard(),

        BasicLayoutSection(
          label: t.championSelect.positionLabel,
          title: championSelect.position?.displayName ?? t.championSelect.unavailable,
        ),
        _SpellCard(),
      ],
    );
  }
}

class const _ChampionCard() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final championSelect = context.watch<ChampionSelectCubit>().state.championSelect;
    final championTitle = championSelect.champion?.name ?? t.championSelect.noChampion;
    final availability = championSelect.actionAvailability;

    if (availability.pickChampion) {
      return InkWell(
        onTap: () => ChampionSelectPickerSheet.showChampion(context, action: .pick),
        borderRadius: const .all(.circular(16)),
        child: BasicLayoutSection(
          label: t.championSelect.pickAction,
          title: championTitle,
          description: t.championSelect.pickGuidance,
        ),
      );
    }

    if (availability.banChampion) {
      return InkWell(
        onTap: () => ChampionSelectPickerSheet.showChampion(context, action: .ban),
        borderRadius: const .all(.circular(16)),
        child: BasicLayoutSection(
          label: t.championSelect.banAction,
          title: championTitle,
          description: t.championSelect.banGuidance,
        ),
      );
    }

    return BasicLayoutSection(
      label: t.championSelect.championLabel,
      title: championTitle,
    );
  }
}

class const _SpellCard() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final championSelect = context.watch<ChampionSelectCubit>().state.championSelect;

    return BasicLayoutSection(
      label: t.championSelect.spellsLabel,
      titlePlaceholder: Column(
        children: [
          _SpellRow(
            label: t.championSelect.spell1Label,
            value: championSelect.spell1?.name ?? t.championSelect.unavailable,
            onTap: championSelect.actionAvailability.changeSummonerSpells
                ? () => ChampionSelectPickerSheet.showSpell(context, slot: .first)
                : null,
          ),
          const Divider(),
          _SpellRow(
            label: t.championSelect.spell2Label,
            value: championSelect.spell2?.name ?? t.championSelect.unavailable,
            onTap: championSelect.actionAvailability.changeSummonerSpells
                ? () => ChampionSelectPickerSheet.showSpell(context, slot: .second)
                : null,
          ),
        ],
      ),
    );
  }
}

class const _SpellRow({
  required final String label,
  required final String value,
  this.onTap,
}) extends StatelessWidget {
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: .zero,
    onTap: onTap,
    title: Text(label),
    trailing: Row(
      mainAxisSize: .min,
      children: [
        Text(value),
        if (onTap != null) const Icon(Icons.chevron_right),
      ],
    ),
  );
}

class const _ChampionSelectCountdown({
  required final Duration timeLeft,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final effectiveTimeLeft = timeLeft.nonNegative;
    final seconds = effectiveTimeLeft.inSecondsDouble;

    return TimeCountdown(
      start: max(seconds, 0.001),
      current: seconds,
      drift: 1.5,
      builder: (_, currentSeconds) => BasicLayoutSection(
        label: t.championSelect.timeLeftLabel,
        title: _formatTime(currentSeconds),
        titleFontSize: .large,
        tone: .active,
        icon: Icons.timer_outlined,
      ),
    );
  }

  String _formatTime(double seconds) {
    final timeLeft = seconds.ceil();
    final minutes = timeLeft ~/ 60;
    final remainingSeconds = (timeLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }
}
