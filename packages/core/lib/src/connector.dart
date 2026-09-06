import 'package:remote_rift_utils/remote_rift_utils.dart';
import 'package:time/time.dart';

import 'common/http_client.dart';
import 'game_data_store.dart';
import 'lcu/lcu_api_client.dart';
import 'lcu/lcu_connection.dart';
import 'lcu/lcu_models.dart' as lcu;
import 'mappers/champion_select.dart';
import 'mappers/lobby_role_preferences.dart';
import 'mappers/queue.dart';
import 'models/champ_select_action.dart';
import 'models/queue.dart';
import 'models/response.dart';
import 'models/session.dart';
import 'models/state.dart';
import 'models/status.dart';

class RemoteRiftConnector._init({
  required final LcuApiClient _lcuApi,
  required final GameDataStore _gameDataStore,
}) {
  factory() {
    final lcuApi = LcuApiClient(
      lcuConnection: LcuConnection(parser: LcuLockfileParser(), loader: LcuLockfileLoader()),
      httpClient: ClientFactory.noCertificateVerification(),
    );
    return RemoteRiftConnector._init(
      lcuApi: lcuApi,
      gameDataStore: GameDataStore(lcuApi: lcuApi),
    );
  }

  static final _readyCheckMaxTime = 10.seconds;

  Stream<RemoteRiftResponse<RemoteRiftStatus>> getStatusStream() async* {
    await for (var _ in _tickStream(seconds: 1)) {
      yield await _runCatching(() async {
        final connection = await _lcuApi.getHeartbeatConnection();
        return connection.stableConnection ? .ready : .unavailable;
      });
    }
  }

  Stream<RemoteRiftSession> getCurrentSessionStream() async* {
    RemoteRiftSession? previousSession;
    await for (var _ in _tickStream(seconds: 1)) {
      try {
        if (await _getCurrentSession() case var session when session != previousSession) {
          yield session;
          previousSession = session;
        }
      } catch (error) {
        if (error case LcuConnectionError() || LcuApiClientError()) {
          previousSession = null;
          continue;
        }
        rethrow;
      }
    }
  }

  Future<void> createLobby({required int queueId}) async {
    if (await _getCurrentState() case PreGame()) {
      await _lcuApi.createLobby(queueId: queueId);
    } else {
      throw RemoteRiftStateError.notPreGame;
    }
  }

  Future<void> leaveLobby() async {
    if (await _getCurrentState() case Lobby(state: .idle)) {
      await _lcuApi.deleteLobby();
    } else {
      throw RemoteRiftStateError.notIdleState;
    }
  }

  Future<void> updateLobbyRolePreferences({
    required LobbyRole first,
    required LobbyRole second,
  }) async {
    if (first == second) throw RemoteRiftStateError.invalidRolePreferences;
    if (await _lcuApi.getGameflowPhase() != .lobby) {
      throw RemoteRiftStateError.notIdleState;
    }

    final lobby = await _lcuApi.getLobby();
    if (lobby == null) {
      throw RemoteRiftStateError.notIdleState;
    }
    if (!lobby.gameConfig.showPositionSelector) {
      throw RemoteRiftStateError.rolePreferencesUnavailable;
    }

    final firstPreference = first.toLcuLobbyPositionPreference();
    final secondPreference = second.toLcuLobbyPositionPreference();
    final preferences = lcu.LobbyPositionPreferences(
      firstPreference: firstPreference,
      secondPreference: secondPreference,
    );
    await _lcuApi.updateLocalMemberPositionPreferences(preferences);
  }

  Future<void> searchMatch() async {
    if (await _getCurrentState() case Lobby(state: .idle)) {
      await _lcuApi.startMatchmakingSearch();
    } else {
      throw RemoteRiftStateError.notIdleState;
    }
  }

  Future<void> stopMatchSearch() async {
    if (await _getCurrentState() case Lobby(state: .searching)) {
      await _lcuApi.stopMatchmakingSearch();
    } else {
      throw RemoteRiftStateError.notSearchingState;
    }
  }

  Future<void> acceptMatch() async {
    if (await _getCurrentState() case Found(state: .pending)) {
      await _lcuApi.acceptReadyCheck();
    } else {
      throw RemoteRiftStateError.notPendingState;
    }
  }

  Future<void> declineMatch() async {
    if (await _getCurrentState() case Found(state: .pending)) {
      await _lcuApi.declineReadyCheck();
    } else {
      throw RemoteRiftStateError.notPendingState;
    }
  }

  Future<void> pickChampion({required int championId}) async {
    await _selectChampion(
      championId: championId,
      actionType: .pickChampion,
      lcuActionType: .pick,
    );
  }

  Future<void> banChampion({required int championId}) async {
    await _selectChampion(
      championId: championId,
      actionType: .banChampion,
      lcuActionType: .ban,
    );
  }

  Future<void> lockInChampion() async {
    await _runChampionSelectAction(.lockInChampion, (session, player) async {
      final actionAssignment = session.activeLocalAction;
      final actionId = actionAssignment?.id;
      if (actionId == null || actionAssignment?.type != .pick) {
        throw RemoteRiftStateError.championSelectActionUnavailable;
      }
      await _lcuApi.updateChampSelectAction(
        actionId: actionId,
        update: lcu.ChampSelectActionUpdate(completed: true),
      );
    });
  }

  Future<void> changeSummonerSpell({
    required int spellId,
    required ChampionSelectSummonerSpellSlot slot,
  }) async {
    await _runChampionSelectAction(.changeSummonerSpells, (session, player) async {
      final otherSpellId = switch (slot) {
        .first => player.spell2Id,
        .second => player.spell1Id,
      };
      if (spellId <= 0 || spellId == otherSpellId) {
        throw RemoteRiftStateError.championSelectActionRejected;
      }
      final update = switch (slot) {
        .first => lcu.ChampSelectMySelectionUpdate(spell1Id: spellId),
        .second => lcu.ChampSelectMySelectionUpdate(spell2Id: spellId),
      };
      await _lcuApi.updateMyChampSelectSelection(update);
    });
  }

  Future<ChampionSelectCatalog> getChampionSelectCatalog() async {
    if (await _lcuApi.getGameflowPhase() != .champSelect) {
      throw RemoteRiftStateError.notChampionSelect;
    }
    final (session, champions, spells) = await (
      _lcuApi.getChampSelectSession(),
      _lcuApi.getChampGridChampions(),
      _lcuApi.getSummonerSpells(),
    ).wait;
    if (session.localPlayer == null) {
      throw RemoteRiftStateError.championSelectUnavailable;
    }

    final catalogChampions = champions.toChampionSelectCatalogChampions();
    final catalogSpells = spells.toChampionSelectCatalogSummonerSpells();
    if (catalogChampions.isEmpty || catalogSpells.isEmpty) {
      throw RemoteRiftStateError.championSelectUnavailable;
    }
    return ChampionSelectCatalog(champions: catalogChampions, summonerSpells: catalogSpells);
  }

  Stream<void> _tickStream({required int seconds}) {
    return .periodic(seconds.seconds).startWith(null);
  }

  Future<RemoteRiftResponse<T>> _runCatching<T>(Future<T> Function() resolve) async {
    try {
      return RemoteRiftData(await resolve());
    } catch (error) {
      if (error case LcuConnectionError() || LcuApiClientError()) {
        return RemoteRiftError.unableToConnect;
      } else {
        return RemoteRiftError.unknown;
      }
    }
  }

  Future<RemoteRiftSession> _getCurrentSession() async {
    var (queueName, state) = await (_getQueueNameOrNull(), _getCurrentState()).waitUnwrapped;
    if (state case PreGame()) {
      // Clear the queue if the session data is out of sync with the state.
      queueName = null;
    }
    return RemoteRiftSession(queueName: queueName, state: state);
  }

  Future<String?> _getQueueNameOrNull({bool retry = false}) async {
    try {
      final session = await _lcuApi.getGameflowSession();
      final queue = session.gameData.queue;

      // Retry fetching in rare cases where session data gets desynced
      // from the state before the queue has been initialized.
      if (queue.id == -1 && !retry) {
        await 100.milliseconds.delay;
        return await _getQueueNameOrNull(retry: true);
      }

      final description = queue.description;
      return description.isNotEmpty ? description : null;
    } on LcuApiClientError catch (error) {
      if (error == .requestRejected) {
        return null;
      }
      rethrow;
    }
  }

  Future<RemoteRiftState> _getCurrentState() async {
    final gameflowPhase = await _lcuApi.getGameflowPhase();
    switch (gameflowPhase) {
      case .none:
        final availableQueues = await _getAvailableQueues();
        return PreGame(availableQueues: availableQueues);

      case .lobby:
        final rolePreferences = await _getLobbyRolePreferencesOrNull();
        return Lobby(state: .idle, rolePreferences: rolePreferences);

      case .matchmaking:
        final matchmakingSearch = await _lcuApi.getMatchmakingSearch();
        return switch (matchmakingSearch.searchState) {
          .searching => Lobby(state: .searching),
          .found || .invalid => Unknown(),
        };

      case .readyCheck:
        final readyCheck = await _lcuApi.getReadyCheck();
        switch (readyCheck.state) {
          case .inProgress:
            final GameFoundState state = switch (readyCheck.playerResponse) {
              .none => .pending,
              .accepted => .accepted,
              .declined => .declined,
            };
            final answerTimeLeft = (_readyCheckMaxTime - readyCheck.timer.seconds).nonNegative;
            return Found(
              state: state,
              answerMaxTime: _readyCheckMaxTime,
              answerTimeLeft: answerTimeLeft,
            );

          case .invalid:
            return Unknown();
        }

      case .champSelect:
        return await _getChampionSelectState();

      case .inProgress || .waitingForStats || .preEndOfGame || .endOfGame:
        return InGame();
    }
  }

  Future<RemoteRiftState> _getChampionSelectState() async {
    final session = await _lcuApi.getChampSelectSession();
    final timer = session.timer;
    final phase = timer?.phase?.toChampionSelectPhase();
    final timeLeftInPhase = timer?.adjustedTimeLeftInPhase;
    if (phase == null || timeLeftInPhase == null) return Unknown();

    final player = session.localPlayer;
    final position = player?.assignedPosition?.toChampionSelectPosition();
    final championId = player?.preferredChampionId;
    final actionAvailability = session.toChampionSelectActionAvailability();

    final (champion, spell1, spell2) = await (
      _gameDataStore.getChampion(championId),
      _gameDataStore.getSummonerSpell(player?.spell1Id),
      _gameDataStore.getSummonerSpell(player?.spell2Id),
    ).wait;

    return ChampionSelect(
      phase: phase,
      timeLeft: timeLeftInPhase.milliseconds,
      champion: champion,
      position: position,
      spell1: spell1,
      spell2: spell2,
      actionAvailability: actionAvailability,
    );
  }

  Future<List<GameQueue>> _getAvailableQueues() async {
    final queues = await _lcuApi.getGameQueues();
    return queues.where(GameQueueFilter.shouldDisplay).map(GameQueueMapper.fromLcu).toList();
  }

  Future<LobbyRolePreferences?> _getLobbyRolePreferencesOrNull() async {
    final lobby = await _lcuApi.getLobby();
    if (lobby == null || !lobby.gameConfig.showPositionSelector) {
      return null;
    }

    return lobby.localMember?.toLobbyRolePreferencesOrNull();
  }

  Future<void> _selectChampion({
    required int championId,
    required ChampionSelectActionType actionType,
    required lcu.ChampSelectActionType lcuActionType,
  }) async {
    await _runChampionSelectAction(actionType, (session, player) async {
      final actionAssignment = session.activeLocalAction;
      final actionId = actionAssignment?.id;
      if (championId <= 0 || actionId == null || actionAssignment?.type != lcuActionType) {
        throw RemoteRiftStateError.championSelectActionUnavailable;
      }
      await _lcuApi.updateChampSelectAction(
        actionId: actionId,
        update: lcu.ChampSelectActionUpdate(championId: championId),
      );
    });
  }

  Future<void> _runChampionSelectAction(
    ChampionSelectActionType actionType,
    _ChampionSelectAction execute,
  ) async {
    try {
      if (await _lcuApi.getGameflowPhase() != .champSelect) {
        throw RemoteRiftStateError.notChampionSelect;
      }

      final session = await _lcuApi.getChampSelectSession();
      final player = session.localPlayer;
      if (player == null) {
        throw RemoteRiftStateError.championSelectActionUnavailable;
      }
      final availability = session.toChampionSelectActionAvailability();
      if (!availability.allows(actionType)) {
        throw RemoteRiftStateError.championSelectActionUnavailable;
      }
      await execute(session, player);
    } on LcuApiClientError catch (error) {
      if (error == .requestRejected) {
        throw RemoteRiftStateError.championSelectActionRejected;
      }
      rethrow;
    }
  }
}

enum RemoteRiftStateError implements Exception {
  notPreGame,
  notIdleState,
  notSearchingState,
  notPendingState,
  notChampionSelect,
  championSelectUnavailable,
  championSelectActionUnavailable,
  championSelectActionRejected,
  rolePreferencesUnavailable,
  invalidRolePreferences,
}

typedef _ChampionSelectAction = Future<void> Function(
  lcu.ChampSelectSession,
  lcu.ChampSelectPlayer,
);
