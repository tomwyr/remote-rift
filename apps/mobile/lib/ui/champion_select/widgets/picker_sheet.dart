import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/layout.dart';
import '../../widgets/events_listener.dart';
import '../champion_select_cubit.dart';
import '../champion_select_state.dart';

class const ChampionSelectPickerSheet({
  super.key,
  required final String title,
  required final String guidance,
  required final ChampionSelectCatalogType catalogType,
  required final ChampionSelectAction action,
  required final String? selectedName,
}) extends StatelessWidget {
  static Future<void> showChampion(
    BuildContext context, {
    required ChampionSelectChampionAction action,
  }) async {
    final championSelect = context.read<ChampionSelectCubit>().state.championSelect;

    await _show(
      context,
      title: switch (action) {
        .pick => t.championSelect.pickTitle,
        .ban => t.championSelect.banTitle,
      },
      guidance: switch (action) {
        .pick => t.championSelect.pickGuidance,
        .ban => t.championSelect.banGuidance,
      },
      catalogType: .champions,
      action: switch (action) {
        .pick => .pickChampion,
        .ban => .banChampion,
      },
      selectedName: switch (action) {
        .pick => championSelect.champion?.name,
        .ban => null,
      },
    );
  }

  static Future<void> showSpell(
    BuildContext context, {
    required ChampionSelectSummonerSpellSlot slot,
  }) async {
    final championSelect = context.read<ChampionSelectCubit>().state.championSelect;

    await _show(
      context,
      title: switch (slot) {
        .first => t.championSelect.spell1Title,
        .second => t.championSelect.spell2Title,
      },
      guidance: t.championSelect.spellGuidance,
      catalogType: .summonerSpells,
      action: switch (slot) {
        .first => .firstSpell,
        .second => .secondSpell,
      },
      selectedName: switch (slot) {
        .first => championSelect.spell1?.name,
        .second => championSelect.spell2?.name,
      },
    );
  }

  static Future<void> _show(
    BuildContext context, {
    required String title,
    required String guidance,
    required ChampionSelectCatalogType catalogType,
    required ChampionSelectAction action,
    required String? selectedName,
  }) async {
    final cubit = context.read<ChampionSelectCubit>();
    final maxHeight = MediaQuery.sizeOf(context).height * 0.75;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: .new(maxHeight: maxHeight, minWidth: .infinity),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ChampionSelectPickerSheet(
          title: title,
          guidance: guidance,
          catalogType: catalogType,
          action: action,
          selectedName: selectedName,
        ),
      ),
    );
  }

  void _onEvent(BuildContext context, ChampionSelectEvent event) {
    switch (event) {
      case .actionCompleted:
        Navigator.of(context).pop();
      case .lockedIn:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ChampionSelectCubit>();

    return EventsListener(
      events: cubit.events,
      onEvent: _onEvent,
      child: switch (cubit.state) {
        Initial() || Loading() => _PickerSheetFrame(
          title: title,
          guidance: guidance,
          child: const Center(child: CircularProgressIndicator()),
        ),
        Failed() => _PickerSheetFrame(
          title: title,
          guidance: guidance,
          child: _CatalogFailure(),
        ),
        final Data state => _CatalogPicker(
          state: state,
          title: title,
          guidance: guidance,
          catalogType: catalogType,
          action: action,
          selectedName: selectedName,
        ),
      },
    );
  }
}

class const _PickerSheetFrame({
  required final String title,
  required final String guidance,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const .fromLTRB(20, 4, 20, 12),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            _PickerHeader(title: title, guidance: guidance),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class const _PickerHeader({
  required final String title,
  required final String guidance,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 5),
        Text(guidance),
      ],
    );
  }
}

class const _CatalogFailure() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChampionSelectCubit>();

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        BasicLayoutSection(
          title: t.championSelect.catalogFailureTitle,
          description: t.championSelect.catalogFailed,
          tone: .error,
          icon: Icons.error_outline,
        ),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: cubit.loadCatalog, child: Text(t.championSelect.retry)),
      ],
    );
  }
}

class const _CatalogPicker({
  required final Data state,
  required final String title,
  required final String guidance,
  required final ChampionSelectCatalogType catalogType,
  required final ChampionSelectAction action,
  required final String? selectedName,
}) extends StatefulWidget {
  @override
  State<_CatalogPicker> createState() => _CatalogPickerState();
}

class _CatalogPickerState extends State<_CatalogPicker> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final items = widget.state.entries(widget.catalogType, query: _query);
    final actionStatus = widget.state.statusOf(widget.action);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const .fromLTRB(20, 4, 20, 0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _PickerHeader(title: widget.title, guidance: widget.guidance),
            if (actionStatus == .submitting) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
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
            const SizedBox(height: 12),
            TextField(
              enabled: actionStatus != .submitting,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                labelText: t.championSelect.searchLabel,
                hintText: t.championSelect.search,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text(t.championSelect.noSearchResults))
                  : ListView(
                      children: [
                        for (final entry in items)
                          ListTile(
                            enabled: actionStatus != .submitting,
                            onTap: () => _select(entry.id),
                            selected: entry.name == widget.selectedName,
                            title: Text(entry.name),
                            trailing: entry.name == widget.selectedName
                                ? const Icon(Icons.check)
                                : null,
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _select(int entryId) async {
    final cubit = context.read<ChampionSelectCubit>();
    switch (widget.action) {
      case .pickChampion:
        await cubit.pickChampion(championId: entryId);
      case .banChampion:
        await cubit.banChampion(championId: entryId);
      case .firstSpell:
        await cubit.changeSummonerSpell(spellId: entryId, slot: .first);
      case .secondSpell:
        await cubit.changeSummonerSpell(spellId: entryId, slot: .second);
      case .lockIn:
        return;
    }
  }
}
