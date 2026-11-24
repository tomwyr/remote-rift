import 'package:remote_rift_core/lcu_protocol.dart';

import 'game_catalog.dart';
import 'mappers/position.dart';
import 'simulator_queue.dart';
import 'simulator_stage.dart';

class SimulatedChampionSelect(SimulatorQueue queue, LobbyPositionPreferences preferences) {
  final _actionsByStage = queue.isDraft
      ? {
          SimulatorStage.localBan: _DraftAction(1, 0, .ban),
          SimulatorStage.enemyBan: _DraftAction(2, 5, .ban),
          SimulatorStage.teammatePick: _DraftAction(3, 1, .pick),
          SimulatorStage.enemyPick: _DraftAction(4, 5, .pick),
          SimulatorStage.localPick: _DraftAction(5, 0, .pick),
        }
      : {SimulatorStage.localPick: _DraftAction(1, 0, .pick)..championId = 22};

  final _gameMode = queue.gameMode;
  final _position = queue.isDraft ? preferences.firstPreference.toLcuAssignedPosition() : null;
  var _intendedChampionId = 0;
  var _spell1Id = 4;
  var _spell2Id = queue.isDraft ? 14 : 32;

  ChampSelectSession session(SimulatorStage stage, Duration remaining) {
    return ChampSelectSession(
      localPlayerCellId: 0,
      myTeam: [
        ChampSelectPlayer(
          cellId: 0,
          championId: _lockedPick(.localPick),
          championPickIntent: _intendedChampionId,
          assignedPosition: _position,
          spell1Id: _spell1Id,
          spell2Id: _spell2Id,
        ),
        ChampSelectPlayer(cellId: 1, championId: _lockedPick(.teammatePick)),
      ],
      actions: [
        for (var MapEntry(:key, :value) in _actionsByStage.entries)
          [value.toWire(isInProgress: key == stage)],
      ],
      timer: ChampSelectTimer(
        phase: stage.championSelectPhase,
        adjustedTimeLeftInPhase: remaining.inMilliseconds,
      ),
    );
  }

  void enterPick() {
    if (_isAvailable(_intendedChampionId)) {
      _actionsByStage[SimulatorStage.localPick]?.championId = _intendedChampionId;
    }
  }

  bool updateAction(SimulatorStage stage, int id, ChampSelectActionUpdate update) {
    final action = _actionsByStage[stage];
    if (action == null || action.actorCellId != 0 || action.id != id || action.completed) {
      return false;
    }

    final championId = update.championId ?? action.championId;
    final isNoBan = action.type == .ban && championId == -1;
    if (!isNoBan && !_isAvailable(championId)) return false;

    action.championId = championId;
    action.completed = update.completed ?? false;
    return true;
  }

  bool updateSelection(SimulatorStage stage, ChampSelectMySelectionUpdate update) {
    final intent = update.championPickIntent;
    final firstSpell = update.spell1Id ?? _spell1Id;
    final secondSpell = update.spell2Id ?? _spell2Id;
    if (intent != null && (stage != .planning || !_isAvailable(intent))) return false;
    if (update.championId != null ||
        (intent == null && update.spell1Id == null && update.spell2Id == null)) {
      return false;
    }
    if (firstSpell == secondSpell ||
        !_isSpellAvailable(firstSpell) ||
        !_isSpellAvailable(secondSpell)) {
      return false;
    }

    _intendedChampionId = intent ?? _intendedChampionId;
    _spell1Id = firstSpell;
    _spell2Id = secondSpell;
    return true;
  }

  void completeTurn(SimulatorStage stage) {
    final action = _actionsByStage[stage];
    if (action == null || action.completed) return;
    if (action.championId == 0) {
      if (stage == .localBan) {
        action.championId = -1;
      } else {
        action.championId = championNamesById.keys.firstWhere(
          (id) => id != _intendedChampionId && _isAvailable(id),
        );
      }
    }
    action.completed = true;
  }

  bool _isAvailable(int id) {
    return championNamesById.containsKey(id) &&
        !_actionsByStage.values.any((action) => action.completed && action.championId == id);
  }

  bool _isSpellAvailable(int id) {
    return spells.any(
      (spell) => spell.id == id && spell.gameModes?.contains(_gameMode) == true,
    );
  }

  int _lockedPick(SimulatorStage stage) {
    final action = _actionsByStage[stage];
    return action != null && action.completed ? action.championId : 0;
  }
}

class _DraftAction(final int id, final int actorCellId, final ChampSelectActionType type) {
  var championId = 0;
  var completed = false;

  ChampSelectActionAssignment toWire({required bool isInProgress}) {
    return ChampSelectActionAssignment(
      id: id,
      actorCellId: actorCellId,
      championId: championId,
      completed: completed,
      isInProgress: isInProgress && !completed,
      type: type,
    );
  }
}
