import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

part 'champion_select_state.g.dart';

sealed class const ChampionSelectState({
  required final ChampionSelect championSelect,
}) extends Equatable {
  ChampionSelectActionStatus statusOf(ChampionSelectAction action) => .idle;

  @override
  List<Object?> get props => [championSelect];
}

class const Initial({required super.championSelect}) extends ChampionSelectState;

class const Loading({required super.championSelect}) extends ChampionSelectState;

class const Failed({required super.championSelect}) extends ChampionSelectState;

@CopyWith()
class const Data({
  required super.championSelect,
  required final ChampionSelectCatalog catalog,
  final Map<ChampionSelectAction, ChampionSelectActionStatus> actionStatuses = const {},
}) extends ChampionSelectState {
  @override
  List<Object?> get props => [...super.props, catalog, actionStatuses];

  @override
  ChampionSelectActionStatus statusOf(ChampionSelectAction action) {
    return actionStatuses[action] ?? .idle;
  }

  List<ChampionSelectCatalogEntry> entries(
    ChampionSelectCatalogType type, {
    required String query,
  }) {
    final normalizedQuery = query.toLowerCase();
    final entries = switch (type) {
      .champions => catalog.championEntries(),
      .summonerSpells => catalog.summonterSpellsEntries(),
    };
    return entries.where((entry) {
      return entry.name.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}

class ChampionSelectCatalogEntry({
  required final int id,
  required final String name,
});

enum ChampionSelectCatalogType { champions, summonerSpells }

enum ChampionSelectEvent { actionCompleted, lockedIn }

enum ChampionSelectAction { pickChampion, banChampion, firstSpell, secondSpell, lockIn }

enum ChampionSelectActionStatus { idle, submitting, failed }

extension on ChampionSelectCatalog {
  List<ChampionSelectCatalogEntry> championEntries() {
    return champions
        .map((champion) => ChampionSelectCatalogEntry(id: champion.id, name: champion.name))
        .toList();
  }
}

extension on ChampionSelectCatalog {
  List<ChampionSelectCatalogEntry> summonterSpellsEntries() {
    return summonerSpells
        .map((spell) => ChampionSelectCatalogEntry(id: spell.id, name: spell.name))
        .toList();
  }
}
