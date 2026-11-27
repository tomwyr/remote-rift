import 'dart:async';

import 'package:remote_rift_core/lcu_protocol.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';
import 'package:time/time.dart';

import 'mappers/queue.dart';
import 'simulated_champion_select.dart';
import 'simulator_queue.dart';
import 'simulator_stage.dart';

class Simulator {
  final _elapsed = Stopwatch();
  final _snapshots = StreamController<SimulatorSnapshot>.broadcast();
  Timer? _stageTimer;
  Timer? _countdownTicker;
  var _online = true;
  var _stage = SimulatorStage.home;
  var _stageRevision = 0;
  var _readyCheckStatus = _ReadyCheckStatus.pending;
  var _declineNextMatch = false;
  _Lobby? _lobby;
  SimulatedChampionSelect? _championSelect;

  SimulatorSnapshot get snapshot {
    return (
      online: _online,
      stage: _stage,
      queue: _lobby?.queue,
      timeLeft: _timeLeft,
      readyCheckResponse: _readyCheckStatus.playerResponse,
      declineNextMatch: _declineNextMatch,
    );
  }

  Stream<SimulatorSnapshot> get snapshots => _snapshots.stream;

  bool get isOnline => _online;

  int get stageRevision => _stageRevision;

  GameflowPhase get gameflowPhase => _stage.gameflowPhase;

  GameflowSession? get gameflowSession {
    final queue = _lobby?.queue;
    if (queue == null) return null;

    final gameflowQueue = queue.toLcuGameflowQueue();
    return GameflowSession(gameData: GameflowGameData(queue: gameflowQueue));
  }

  LobbyDetails? get lobby {
    final lobby = _lobby;
    if (lobby == null || !_hasLobbyDetails) return null;

    final queue = lobby.queue;
    final preferences = lobby.preferences;
    return LobbyDetails(
      gameConfig: LobbyGameConfig(queueId: queue.id, showPositionSelector: queue.isDraft),
      localMember: LobbyMember(
        firstPositionPreference: preferences.firstPreference,
        secondPositionPreference: preferences.secondPreference,
      ),
    );
  }

  LobbyPositionPreferences get positionPreferences {
    final lobby = _lobby;
    if (lobby == null || !lobby.queue.isDraft || !_hasLobbyDetails) {
      throw SimulatorRequestError.invalidState;
    }
    return lobby.preferences;
  }

  MatchmakingSearch get matchmakingSearch {
    final searchState = switch (_stage) {
      .searching => MatchmakingSearchState.searching,
      .readyCheck => MatchmakingSearchState.found,
      _ => MatchmakingSearchState.invalid,
    };
    return MatchmakingSearch(searchState: searchState);
  }

  ReadyCheck get readyCheck {
    final inProgress = _stage == .readyCheck;
    return ReadyCheck(
      state: inProgress ? .inProgress : .invalid,
      timer: inProgress ? _elapsed.elapsed.inSeconds.toDouble() : 0,
      playerResponse: inProgress ? _readyCheckStatus.playerResponse : .none,
    );
  }

  ChampSelectSession get championSelectSession {
    final (championSelect, timeLeft) = _activeChampionSelect();
    return championSelect.session(_stage, timeLeft);
  }

  Duration? get _timeLeft {
    final duration = _stage.duration;
    return duration == null ? null : (duration - _elapsed.elapsed).nonNegative;
  }

  bool get _hasLobbyDetails {
    return switch (_stage) {
      .lobby || .searching || .readyCheck => true,
      _ => false,
    };
  }

  void setOnline(bool online) {
    if (_online == online) return;
    _online = online;
    if (!online) {
      reset();
    } else {
      _publishSnapshot();
    }
  }

  void setDeclineNextMatch(bool decline) {
    if (_declineNextMatch == decline) return;
    _declineNextMatch = decline;
    _publishSnapshot();
  }

  void reset() {
    _lobby = null;
    _championSelect = null;
    _declineNextMatch = false;
    _readyCheckStatus = .pending;
    _enter(.home);
  }

  void createLobby(SimulatorQueue queue) {
    _requireStage(.home);
    _lobby = _Lobby(queue);
    _enter(.lobby);
  }

  void leaveLobby() {
    _requireStage(.lobby);
    reset();
  }

  void updatePositionPreferences(LobbyPositionPreferences preferences) {
    _requireStage(.lobby);
    final lobby = _lobby;
    if (lobby == null || !lobby.queue.isDraft) throw SimulatorRequestError.invalidState;
    if (preferences.firstPreference == preferences.secondPreference) {
      throw SimulatorRequestError.invalidInput;
    }
    lobby.preferences = preferences;
  }

  void startSearch() {
    _requireStage(.lobby);
    _enter(.searching);
  }

  void stopSearch() {
    _requireStage(.searching);
    _enter(.lobby);
  }

  void answerReadyCheck(ReadyCheckResponse response) {
    _requireStage(.readyCheck);
    if (_readyCheckStatus != .pending) throw SimulatorRequestError.invalidState;

    _readyCheckStatus = switch (response) {
      .none => throw SimulatorRequestError.invalidInput,
      .accepted when _declineNextMatch => .declinedByAnotherPlayer,
      .accepted => .accepted,
      .declined => .declined,
    };
    if (response == .accepted) {
      _declineNextMatch = false;
    }
    _stageTimer?.cancel();
    _stageTimer = Timer(2.seconds, advance);
    _publishSnapshot();
  }

  void updateChampionAction(int id, ChampSelectActionUpdate update) {
    final (championSelect, _) = _activeChampionSelect();
    if (!championSelect.updateAction(_stage, id, update)) {
      throw SimulatorRequestError.invalidInput;
    }
    if (update.completed == true) {
      advance();
    }
  }

  void updateChampionSelection(ChampSelectMySelectionUpdate update) {
    final (championSelect, _) = _activeChampionSelect();
    if (!championSelect.updateSelection(update)) {
      throw SimulatorRequestError.invalidInput;
    }
  }

  void advance() {
    switch (_stage) {
      case .home || .lobby:
        return;
      case .searching:
        _readyCheckStatus = .pending;
        _enter(.readyCheck);
      case .readyCheck:
        final status = _readyCheckStatus;
        _readyCheckStatus = .pending;
        if (_lobby case var lobby? when status == .accepted) {
          final queue = lobby.queue;
          _championSelect = SimulatedChampionSelect(queue, lobby.preferences);
          _enter(queue.isDraft ? .planning : .localPick);
        } else {
          _enter(.lobby);
        }
      case .planning:
        _enter(.localBan);
      case .localBan:
        _championSelect?.completeTurn(.localBan);
        _enter(.enemyBan);
      case .enemyBan:
        _championSelect?.completeTurn(.enemyBan);
        _enter(.teammatePick);
      case .teammatePick:
        _championSelect?.completeTurn(.teammatePick);
        _enter(.enemyPick);
      case .enemyPick:
        _championSelect?.completeTurn(.enemyPick);
        _championSelect?.enterPick();
        _enter(.localPick);
      case .localPick:
        _championSelect?.completeTurn(.localPick);
        _enter(.finalization);
      case .finalization:
        _enter(.gameStarting);
      case .gameStarting:
        _championSelect = null;
        _enter(.inGame);
      case .inGame:
        _enter(.waitingForStats);
      case .waitingForStats:
        _enter(.preEndOfGame);
      case .preEndOfGame:
        _enter(.endOfGame);
      case .endOfGame:
        _enter(.lobby);
    }
  }

  Future<void> close() async {
    _stageTimer?.cancel();
    _countdownTicker?.cancel();
    _elapsed.stop();
    await _snapshots.close();
  }

  void _requireStage(SimulatorStage stage) {
    if (!_online || _stage != stage) throw SimulatorRequestError.invalidState;
  }

  (SimulatedChampionSelect, Duration) _activeChampionSelect() {
    if ((_championSelect, _timeLeft) case (var championSelect?, var timeLeft?) when _online) {
      return (championSelect, timeLeft);
    }
    throw SimulatorRequestError.invalidState;
  }

  void _enter(SimulatorStage stage) {
    _stageTimer?.cancel();
    _countdownTicker?.cancel();
    _elapsed
      ..stop()
      ..reset();
    _stage = stage;
    _stageRevision++;
    if (stage.duration case var duration?) {
      _elapsed.start();
      _stageTimer = Timer(duration, _expireStage);
      _countdownTicker = Timer.periodic(250.milliseconds, (_) => _publishSnapshot());
    }
    _publishSnapshot();
  }

  void _expireStage() {
    if (_stage == .localPick && _lobby?.queue.isDraft == true) {
      _championSelect = null;
      _enter(.lobby);
      return;
    }
    advance();
  }

  void _publishSnapshot() {
    _snapshots.add(snapshot);
  }
}

typedef SimulatorSnapshot = ({
  bool online,
  SimulatorStage stage,
  SimulatorQueue? queue,
  Duration? timeLeft,
  ReadyCheckResponse readyCheckResponse,
  bool declineNextMatch,
});

enum SimulatorRequestError implements Exception { invalidInput, invalidState }

class _Lobby(final SimulatorQueue queue) {
  var preferences = LobbyPositionPreferences(
    firstPreference: .unselected,
    secondPreference: .unselected,
  );
}

enum _ReadyCheckStatus(final ReadyCheckResponse playerResponse) {
  pending(.none),
  accepted(.accepted),
  declined(.declined),
  declinedByAnotherPlayer(.accepted),
}
