import '../lcu/lcu_models.dart' as lcu;
import '../models/champ_select_action.dart';
import '../models/state.dart';

extension ChampSelectSessionExtensions on lcu.ChampSelectSession {
  lcu.ChampSelectPlayer? get localPlayer {
    final cellId = localPlayerCellId;
    if (cellId == null) return null;

    for (final player in myTeam) {
      if (player.cellId == cellId) return player;
    }
    return null;
  }

  lcu.ChampSelectActionAssignment? get activeLocalAction {
    final cellId = localPlayerCellId;
    if (cellId == null) return null;

    for (final round in actions) {
      for (final action in round) {
        if (action.actorCellId == cellId &&
            action.isInProgress == true &&
            action.completed != true) {
          return action;
        }
      }
    }
    return null;
  }
}

extension ChampSelectPlayerExtensions on lcu.ChampSelectPlayer {
  int? get preferredChampionId {
    if (championId case var id? when id > 0) {
      return id;
    }
    if (championPickIntent case var intent? when intent > 0) {
      return intent;
    }
    return null;
  }
}

extension ChampSelectSessionAvailabilityMapper on lcu.ChampSelectSession {
  ChampionSelectActionAvailability toChampionSelectActionAvailability() {
    final timeLeft = timer?.adjustedTimeLeftInPhase;
    if (localPlayer == null || timeLeft == null || timeLeft <= 0) {
      return .unavailable;
    }
    return switch (activeLocalAction?.type) {
      .pick => .pick,
      .ban => .ban,
      null => .unavailable,
    };
  }
}

extension ChampSelectTimerPhaseMapper on lcu.ChampSelectTimerPhase {
  ChampionSelectPhase toChampionSelectPhase() {
    return switch (this) {
      .planning => .planning,
      .banPick => .banPick,
      .finalization => .finalization,
    };
  }
}

extension ChampSelectAssignedPositionMapper on lcu.ChampSelectAssignedPosition {
  ChampionSelectPosition toChampionSelectPosition() {
    return switch (this) {
      .top => .top,
      .jungle => .jungle,
      .middle => .middle,
      .bottom => .bottom,
      .utility => .support,
    };
  }
}

extension ChampGridChampionIterableMapper on Iterable<lcu.ChampGridChampion> {
  Map<int, Champion> toChampionsById() {
    return _valuesById(map((champion) => (champion.id, champion.toChampionOrNull())));
  }

  List<ChampionSelectCatalogChampion> toChampionSelectCatalogChampions() {
    final catalogChampions = map(
      (champion) => (champion.id, champion.toChampionSelectCatalogChampionOrNull()),
    );
    return _valuesById(catalogChampions).values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }
}

extension SummonerSpellIterableMapper on Iterable<lcu.SummonerSpell> {
  Map<int, SummonerSpell> toSummonerSpellsById() {
    return _valuesById(map((spell) => (spell.id, spell.toSummonerSpellOrNull())));
  }

  List<ChampionSelectCatalogSummonerSpell> toChampionSelectCatalogSummonerSpells() {
    final catalogSpells = map(
      (spell) => (spell.id, spell.toChampionSelectCatalogSummonerSpellOrNull()),
    );
    return _valuesById(catalogSpells).values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }
}

extension ChampGridChampionMapper on lcu.ChampGridChampion {
  Champion? toChampionOrNull() {
    final name = this.name;
    return name == null || name.isEmpty ? null : Champion(name: name);
  }

  ChampionSelectCatalogChampion? toChampionSelectCatalogChampionOrNull() {
    final id = this.id;
    final name = this.name;
    if (id == null || id <= 0 || name == null || name.isEmpty) {
      return null;
    }
    return ChampionSelectCatalogChampion(id: id, name: name);
  }
}

extension SummonerSpellMapper on lcu.SummonerSpell {
  SummonerSpell? toSummonerSpellOrNull() {
    final name = this.name;
    return name == null || name.isEmpty ? null : SummonerSpell(name: name);
  }

  ChampionSelectCatalogSummonerSpell? toChampionSelectCatalogSummonerSpellOrNull() {
    final id = this.id;
    final name = this.name;
    if (id == null || id <= 0 || name == null || name.isEmpty) {
      return null;
    }
    return ChampionSelectCatalogSummonerSpell(id: id, name: name);
  }
}

Map<int, T> _valuesById<T>(Iterable<(int?, T?)> values) {
  final mappedValues = <int, T>{};
  for (final (id, value) in values) {
    if (id != null && id > 0 && value != null) mappedValues[id] = value;
  }
  return mappedValues;
}
