// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lcu_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameflowSession _$GameflowSessionFromJson(Map<String, dynamic> json) =>
    GameflowSession(
      gameData: GameflowGameData.fromJson(
        json['gameData'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GameflowSessionToJson(GameflowSession instance) =>
    <String, dynamic>{'gameData': instance.gameData};

GameflowGameData _$GameflowGameDataFromJson(Map<String, dynamic> json) =>
    GameflowGameData(
      queue: GameflowQueue.fromJson(json['queue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameflowGameDataToJson(GameflowGameData instance) =>
    <String, dynamic>{'queue': instance.queue};

GameflowQueue _$GameflowQueueFromJson(Map<String, dynamic> json) =>
    GameflowQueue(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$GameflowQueueToJson(GameflowQueue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

ChampSelectSession _$ChampSelectSessionFromJson(Map<String, dynamic> json) =>
    ChampSelectSession(
      localPlayerCellId: (json['localPlayerCellId'] as num?)?.toInt(),
      myTeam:
          (json['myTeam'] as List<dynamic>?)
              ?.map(
                (e) => ChampSelectPlayer.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map(
                (e) => (e as List<dynamic>)
                    .map(
                      (e) => ChampSelectActionAssignment.fromJson(
                        e as Map<String, dynamic>,
                      ),
                    )
                    .toList(),
              )
              .toList() ??
          const [],
      timer: json['timer'] == null
          ? null
          : ChampSelectTimer.fromJson(json['timer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChampSelectSessionToJson(ChampSelectSession instance) =>
    <String, dynamic>{
      'localPlayerCellId': instance.localPlayerCellId,
      'myTeam': instance.myTeam,
      'actions': instance.actions,
      'timer': instance.timer,
    };

ChampSelectActionAssignment _$ChampSelectActionAssignmentFromJson(
  Map<String, dynamic> json,
) => ChampSelectActionAssignment(
  id: (json['id'] as num?)?.toInt(),
  actorCellId: (json['actorCellId'] as num?)?.toInt(),
  completed: json['completed'] as bool?,
  isInProgress: json['isInProgress'] as bool?,
  type: $enumDecodeNullable(_$ChampSelectActionTypeEnumMap, json['type']),
);

Map<String, dynamic> _$ChampSelectActionAssignmentToJson(
  ChampSelectActionAssignment instance,
) => <String, dynamic>{
  'id': instance.id,
  'actorCellId': instance.actorCellId,
  'completed': instance.completed,
  'isInProgress': instance.isInProgress,
  'type': _$ChampSelectActionTypeEnumMap[instance.type],
};

const _$ChampSelectActionTypeEnumMap = {
  ChampSelectActionType.pick: 'pick',
  ChampSelectActionType.ban: 'ban',
};

ChampSelectActionUpdate _$ChampSelectActionUpdateFromJson(
  Map<String, dynamic> json,
) => ChampSelectActionUpdate(
  championId: (json['championId'] as num?)?.toInt(),
  completed: json['completed'] as bool?,
);

Map<String, dynamic> _$ChampSelectActionUpdateToJson(
  ChampSelectActionUpdate instance,
) => <String, dynamic>{
  'championId': ?instance.championId,
  'completed': ?instance.completed,
};

ChampSelectPlayer _$ChampSelectPlayerFromJson(Map<String, dynamic> json) =>
    ChampSelectPlayer(
      cellId: (json['cellId'] as num?)?.toInt(),
      championId: (json['championId'] as num?)?.toInt(),
      championPickIntent: (json['championPickIntent'] as num?)?.toInt(),
      assignedPosition: $enumDecodeNullable(
        _$ChampSelectAssignedPositionEnumMap,
        json['assignedPosition'],
      ),
      spell1Id: (json['spell1Id'] as num?)?.toInt(),
      spell2Id: (json['spell2Id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChampSelectPlayerToJson(ChampSelectPlayer instance) =>
    <String, dynamic>{
      'cellId': instance.cellId,
      'championId': instance.championId,
      'championPickIntent': instance.championPickIntent,
      'assignedPosition':
          _$ChampSelectAssignedPositionEnumMap[instance.assignedPosition],
      'spell1Id': instance.spell1Id,
      'spell2Id': instance.spell2Id,
    };

const _$ChampSelectAssignedPositionEnumMap = {
  ChampSelectAssignedPosition.top: 'TOP',
  ChampSelectAssignedPosition.jungle: 'JUNGLE',
  ChampSelectAssignedPosition.middle: 'MIDDLE',
  ChampSelectAssignedPosition.bottom: 'BOTTOM',
  ChampSelectAssignedPosition.utility: 'UTILITY',
};

ChampSelectMySelectionUpdate _$ChampSelectMySelectionUpdateFromJson(
  Map<String, dynamic> json,
) => ChampSelectMySelectionUpdate(
  spell1Id: (json['spell1Id'] as num?)?.toInt(),
  spell2Id: (json['spell2Id'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChampSelectMySelectionUpdateToJson(
  ChampSelectMySelectionUpdate instance,
) => <String, dynamic>{
  'spell1Id': ?instance.spell1Id,
  'spell2Id': ?instance.spell2Id,
};

ChampSelectTimer _$ChampSelectTimerFromJson(Map<String, dynamic> json) =>
    ChampSelectTimer(
      phase: $enumDecodeNullable(_$ChampSelectTimerPhaseEnumMap, json['phase']),
      adjustedTimeLeftInPhase: (json['adjustedTimeLeftInPhase'] as num?)
          ?.toInt(),
    );

Map<String, dynamic> _$ChampSelectTimerToJson(ChampSelectTimer instance) =>
    <String, dynamic>{
      'phase': _$ChampSelectTimerPhaseEnumMap[instance.phase],
      'adjustedTimeLeftInPhase': instance.adjustedTimeLeftInPhase,
    };

const _$ChampSelectTimerPhaseEnumMap = {
  ChampSelectTimerPhase.planning: 'PLANNING',
  ChampSelectTimerPhase.banPick: 'BAN_PICK',
  ChampSelectTimerPhase.finalization: 'FINALIZATION',
};

ChampGridChampion _$ChampGridChampionFromJson(Map<String, dynamic> json) =>
    ChampGridChampion(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ChampGridChampionToJson(ChampGridChampion instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

SummonerSpell _$SummonerSpellFromJson(Map<String, dynamic> json) =>
    SummonerSpell(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$SummonerSpellToJson(SummonerSpell instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

GameQueue _$GameQueueFromJson(Map<String, dynamic> json) => GameQueue(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  gameMode: json['gameMode'] as String,
  gameSelectCategory: json['gameSelectCategory'] as String,
  gameSelectModeGroup: json['gameSelectModeGroup'] as String,
  isEnabled: json['isEnabled'] as bool,
  isVisible: json['isVisible'] as bool,
  isCustom: json['isCustom'] as bool,
);

Map<String, dynamic> _$GameQueueToJson(GameQueue instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'gameMode': instance.gameMode,
  'gameSelectCategory': instance.gameSelectCategory,
  'gameSelectModeGroup': instance.gameSelectModeGroup,
  'isEnabled': instance.isEnabled,
  'isVisible': instance.isVisible,
  'isCustom': instance.isCustom,
};

LobbyDetails _$LobbyDetailsFromJson(Map<String, dynamic> json) => LobbyDetails(
  gameConfig: LobbyGameConfig.fromJson(
    json['gameConfig'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$LobbyDetailsToJson(LobbyDetails instance) =>
    <String, dynamic>{'gameConfig': instance.gameConfig};

LobbyGameConfig _$LobbyGameConfigFromJson(Map<String, dynamic> json) =>
    LobbyGameConfig(queueId: (json['queueId'] as num).toInt());

Map<String, dynamic> _$LobbyGameConfigToJson(LobbyGameConfig instance) =>
    <String, dynamic>{'queueId': instance.queueId};

LobbyPositionPreferences _$LobbyPositionPreferencesFromJson(
  Map<String, dynamic> json,
) => LobbyPositionPreferences(
  firstPreference: $enumDecodeNullable(
    _$LobbyPositionPreferenceEnumMap,
    json['firstPreference'],
  ),
  secondPreference: $enumDecodeNullable(
    _$LobbyPositionPreferenceEnumMap,
    json['secondPreference'],
  ),
);

Map<String, dynamic> _$LobbyPositionPreferencesToJson(
  LobbyPositionPreferences instance,
) => <String, dynamic>{
  'firstPreference': _$LobbyPositionPreferenceEnumMap[instance.firstPreference],
  'secondPreference':
      _$LobbyPositionPreferenceEnumMap[instance.secondPreference],
};

const _$LobbyPositionPreferenceEnumMap = {
  LobbyPositionPreference.unselected: 'UNSELECTED',
  LobbyPositionPreference.fill: 'FILL',
  LobbyPositionPreference.top: 'TOP',
  LobbyPositionPreference.jungle: 'JUNGLE',
  LobbyPositionPreference.middle: 'MIDDLE',
  LobbyPositionPreference.bottom: 'BOTTOM',
  LobbyPositionPreference.utility: 'UTILITY',
};

MatchmakingSearch _$MatchmakingSearchFromJson(Map<String, dynamic> json) =>
    MatchmakingSearch(
      searchState: $enumDecode(
        _$MatchmakingSearchStateEnumMap,
        json['searchState'],
      ),
    );

Map<String, dynamic> _$MatchmakingSearchToJson(MatchmakingSearch instance) =>
    <String, dynamic>{
      'searchState': _$MatchmakingSearchStateEnumMap[instance.searchState]!,
    };

const _$MatchmakingSearchStateEnumMap = {
  MatchmakingSearchState.invalid: 'Invalid',
  MatchmakingSearchState.searching: 'Searching',
  MatchmakingSearchState.found: 'Found',
};

ReadyCheck _$ReadyCheckFromJson(Map<String, dynamic> json) => ReadyCheck(
  state: $enumDecode(_$ReadyCheckStateEnumMap, json['state']),
  timer: (json['timer'] as num).toDouble(),
  playerResponse: $enumDecode(
    _$ReadyCheckResponseEnumMap,
    json['playerResponse'],
  ),
);

Map<String, dynamic> _$ReadyCheckToJson(ReadyCheck instance) =>
    <String, dynamic>{
      'state': _$ReadyCheckStateEnumMap[instance.state]!,
      'timer': instance.timer,
      'playerResponse': _$ReadyCheckResponseEnumMap[instance.playerResponse]!,
    };

const _$ReadyCheckStateEnumMap = {
  ReadyCheckState.invalid: 'Invalid',
  ReadyCheckState.inProgress: 'InProgress',
};

const _$ReadyCheckResponseEnumMap = {
  ReadyCheckResponse.none: 'None',
  ReadyCheckResponse.accepted: 'Accepted',
  ReadyCheckResponse.declined: 'Declined',
};

ReadyCheckError _$ReadyCheckErrorFromJson(Map<String, dynamic> json) =>
    ReadyCheckError(
      httpStatus: (json['httpStatus'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$ReadyCheckErrorToJson(ReadyCheckError instance) =>
    <String, dynamic>{
      'httpStatus': instance.httpStatus,
      'message': instance.message,
    };

HeartbeatConnection _$HeartbeatConnectionFromJson(Map<String, dynamic> json) =>
    HeartbeatConnection(stableConnection: json['stableConnection'] as bool);

Map<String, dynamic> _$HeartbeatConnectionToJson(
  HeartbeatConnection instance,
) => <String, dynamic>{'stableConnection': instance.stableConnection};

const _$GameflowPhaseEnumMap = {
  GameflowPhase.none: 'None',
  GameflowPhase.lobby: 'Lobby',
  GameflowPhase.matchmaking: 'Matchmaking',
  GameflowPhase.readyCheck: 'ReadyCheck',
  GameflowPhase.champSelect: 'ChampSelect',
  GameflowPhase.inProgress: 'InProgress',
  GameflowPhase.waitingForStats: 'WaitingForStats',
  GameflowPhase.preEndOfGame: 'PreEndOfGame',
  GameflowPhase.endOfGame: 'EndOfGame',
};
