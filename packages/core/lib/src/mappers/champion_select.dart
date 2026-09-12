import '../lcu/lcu_models.dart' as lcu;
import '../models/champ_select_action.dart';
import '../models/state.dart';

extension ChampSelectSessionExtensions on lcu.ChampSelectSession {
  lcu.ChampSelectPlayer? get localPlayer {
    final cellId = localPlayerCellId;
    if (cellId == null) return null;

    for (var player in myTeam) {
      if (player.cellId == cellId) return player;
    }
    return null;
  }

  lcu.ChampSelectActionAssignment? get activeLocalAction {
    final cellId = localPlayerCellId;
    if (cellId == null) return null;

    for (var actionTurn in actions) {
      for (var action in actionTurn) {
        if (action.actorCellId == cellId &&
            action.isInProgress == true &&
            action.completed != true) {
          return action;
        }
      }
    }
    return null;
  }

  lcu.ChampSelectActionAssignment? get localChampionActionAssignment {
    if (activeLocalAction case var action?) {
      return action;
    }

    final cellId = localPlayerCellId;
    if (cellId == null) {
      return null;
    }

    for (var actionTurn in actions.reversed) {
      for (var action in actionTurn.reversed) {
        if (action.hasLockedChampionForCell(cellId)) {
          return action;
        }
      }
    }
    return null;
  }

  int? get localChampionId {
    final championId = localChampionActionAssignment?.championId;
    return championId != null && championId > 0 ? championId : null;
  }

  ChampionSelectChampionAction? get localChampionAction {
    return switch (localChampionActionAssignment?.type) {
      .pick => .pick,
      .ban => .ban,
      _ => null,
    };
  }

  List<int> get unavailableChampionIds {
    final championIds = <int>{};
    for (var actionTurn in actions) {
      for (var action in actionTurn) {
        if (action.bannedChampionId case var championId?) {
          championIds.add(championId);
        }
      }
    }

    final localCellId = localPlayerCellId;
    for (var player in myTeam) {
      if (player.cellId == localCellId) {
        continue;
      }
      final championId = player.preferredChampionId;
      if (championId != null) {
        championIds.add(championId);
      }
    }

    return championIds.toList();
  }

  lcu.ChampSelectActionAssignment? actionWithId(int actionId) {
    for (var actionTurn in actions) {
      for (var action in actionTurn) {
        if (action.id == actionId) {
          return action;
        }
      }
    }
    return null;
  }
}

extension ChampSelectActionAssignmentExtensions on lcu.ChampSelectActionAssignment {
  int? get bannedChampionId {
    if (type != .ban || completed != true) {
      return null;
    }
    if (championId case var selectedChampionId? when selectedChampionId > 0) {
      return selectedChampionId;
    }
    return null;
  }

  bool hasLockedChampionForCell(int cellId) {
    final selectedChampionId = championId;
    return actorCellId == cellId &&
        completed == true &&
        selectedChampionId != null &&
        selectedChampionId > 0;
  }
}

extension ChampSelectActionTypeExtensions on lcu.ChampSelectActionType? {
  bool get isPickOrBan => this == .pick || this == .ban;
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
    if (timer?.phase == .planning) {
      return .spells;
    }
    return switch (activeLocalAction?.type) {
      .pick => .pick,
      .ban => .ban,
      _ => .spells,
    };
  }
}

extension ChampSelectTimerPhaseMapper on lcu.ChampSelectTimerPhase {
  ChampionSelectPhase toChampionSelectPhase() {
    return switch (this) {
      .planning => .planning,
      .banPick => .banPick,
      .finalization => .finalization,
      .gameStarting => .gameStarting,
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
    final championsByName = <String, ChampionSelectCatalogChampion>{};
    for (var champion in this) {
      final catalogChampion = champion.toChampionSelectCatalogChampionOrNull();
      if (catalogChampion == null) {
        continue;
      }
      final existing = championsByName[catalogChampion.name];
      if (existing == null || catalogChampion.id < existing.id) {
        championsByName[catalogChampion.name] = catalogChampion;
      }
    }
    return championsByName.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }
}

extension SummonerSpellIterableMapper on Iterable<lcu.SummonerSpell> {
  Map<int, SummonerSpell> toSummonerSpellsById() {
    return _valuesById(map((spell) => (spell.id, spell.toSummonerSpellOrNull())));
  }

  List<ChampionSelectCatalogSummonerSpell> toChampionSelectCatalogSummonerSpells() {
    final spellsByName = <String, ChampionSelectCatalogSummonerSpell>{};
    for (var spell in this) {
      final catalogSpell = spell.toChampionSelectCatalogSummonerSpellOrNull();
      if (catalogSpell == null) {
        continue;
      }
      final existing = spellsByName[catalogSpell.name];
      if (existing == null || catalogSpell.id < existing.id) {
        spellsByName[catalogSpell.name] = catalogSpell;
      }
    }
    return spellsByName.values.toList()..sort((a, b) => a.name.compareTo(b.name));
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
  for (var (id, value) in values) {
    if (id != null && id > 0 && value != null) mappedValues[id] = value;
  }
  return mappedValues;
}
