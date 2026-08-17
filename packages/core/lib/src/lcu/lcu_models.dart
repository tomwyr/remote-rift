import 'package:json_annotation/json_annotation.dart';

part 'lcu_models.g.dart';

@JsonEnum(alwaysCreate: true, fieldRename: .pascal)
enum GameflowPhase {
  none,
  lobby,
  matchmaking,
  readyCheck,
  champSelect,
  inProgress,
  waitingForStats,
  preEndOfGame,
  endOfGame;

  factory fromJson(String json) {
    return $enumDecode(_$GameflowPhaseEnumMap, json);
  }
}

@JsonSerializable()
class GameflowSession({
  required final GameflowGameData gameData,
}) {
  factory fromJson(Map<String, dynamic> json) => _$GameflowSessionFromJson(json);

  Map<String, dynamic> toJson() => _$GameflowSessionToJson(this);
}

@JsonSerializable()
class GameflowGameData({
  required final GameflowQueue queue,
}) {
  factory fromJson(Map<String, dynamic> json) => _$GameflowGameDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameflowGameDataToJson(this);
}

@JsonSerializable()
class GameflowQueue({
  required final int id,
  required final String name,
  required final String description,
}) {
  factory fromJson(Map<String, dynamic> json) => _$GameflowQueueFromJson(json);

  Map<String, dynamic> toJson() => _$GameflowQueueToJson(this);
}

@JsonSerializable()
class GameQueue({
  required final int id,
  required final String name,
  required final String description,
  required final String gameMode,
  required final String gameSelectCategory,
  required final String gameSelectModeGroup,
  required final bool isEnabled,
  required final bool isVisible,
  required final bool isCustom,
}) {
  factory fromJson(Map<String, dynamic> json) => _$GameQueueFromJson(json);

  Map<String, dynamic> toJson() => _$GameQueueToJson(this);
}

class GameSelectCategory {
  static const pvp = 'kPvP';
  static const versusAi = 'kVersusAI';
}

class GameSelectModeGroup {
  static const summonersRift = 'kSummonersRift';
  static const aram = 'kARAM';
  static const alternativeLeagueGameModes = 'kAlternativeLeagueGameModes';
  static const teamfightTactics = 'kTeamfightTactics';
}

@JsonSerializable()
class MatchmakingSearch({
  required final MatchmakingSearchState searchState,
}) {
  factory fromJson(Map<String, dynamic> json) => _$MatchmakingSearchFromJson(json);

  Map<String, dynamic> toJson() => _$MatchmakingSearchToJson(this);
}

@JsonEnum(fieldRename: .pascal)
enum MatchmakingSearchState { invalid, searching, found }

@JsonSerializable()
class ReadyCheck({
  required final ReadyCheckState state,
  required final double timer,
  required final ReadyCheckResponse playerResponse,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ReadyCheckFromJson(json);

  Map<String, dynamic> toJson() => _$ReadyCheckToJson(this);
}

@JsonEnum(fieldRename: .pascal)
enum ReadyCheckState { invalid, inProgress }

@JsonEnum(fieldRename: .pascal)
enum ReadyCheckResponse { none, accepted, declined }

@JsonSerializable()
class ReadyCheckError({
  required final int httpStatus,
  required final String message,
}) implements Exception {
  factory fromJson(Map<String, dynamic> json) => _$ReadyCheckErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ReadyCheckErrorToJson(this);
}

@JsonSerializable()
class HeartbeatConnection({
  required final bool stableConnection,
}) {
  factory fromJson(Map<String, dynamic> json) => _$HeartbeatConnectionFromJson(json);

  Map<String, dynamic> toJson() => _$HeartbeatConnectionToJson(this);
}
