import 'package:json_annotation/json_annotation.dart';

import 'lcu_converters.dart';

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
class ChampSelectSession({
  final int? localPlayerCellId,
  final List<ChampSelectPlayer> myTeam = const [],
  final List<List<ChampSelectActionAssignment>> actions = const [],
  final ChampSelectTimer? timer,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ChampSelectSessionFromJson(json);

  Map<String, dynamic> toJson() => _$ChampSelectSessionToJson(this);
}

@JsonSerializable()
class ChampSelectActionAssignment({
  final int? id,
  final int? actorCellId,
  final bool? completed,
  final bool? isInProgress,
  final ChampSelectActionType? type,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ChampSelectActionAssignmentFromJson(json);

  Map<String, dynamic> toJson() => _$ChampSelectActionAssignmentToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ChampSelectActionUpdate({
  final int? championId,
  final bool? completed,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ChampSelectActionUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ChampSelectActionUpdateToJson(this);
}

@JsonEnum(fieldRename: .snake)
enum ChampSelectActionType { pick, ban }

@JsonSerializable()
class ChampSelectPlayer({
  final int? cellId,
  final int? championId,
  final int? championPickIntent,
  final ChampSelectAssignedPosition? assignedPosition,
  final int? spell1Id,
  final int? spell2Id,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ChampSelectPlayerFromJson(json);

  Map<String, dynamic> toJson() => _$ChampSelectPlayerToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ChampSelectMySelectionUpdate({
  final int? spell1Id,
  final int? spell2Id,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ChampSelectMySelectionUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$ChampSelectMySelectionUpdateToJson(this);
}

@JsonEnum(fieldRename: .screamingSnake)
enum ChampSelectAssignedPosition { top, jungle, middle, bottom, utility }

@JsonSerializable()
class ChampSelectTimer({
  final ChampSelectTimerPhase? phase,
  final int? adjustedTimeLeftInPhase,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ChampSelectTimerFromJson(json);

  Map<String, dynamic> toJson() => _$ChampSelectTimerToJson(this);
}

@JsonEnum(fieldRename: .screamingSnake)
enum ChampSelectTimerPhase {
  planning,
  banPick,
  finalization,
}

@JsonSerializable()
class ChampGridChampion({
  final int? id,
  final String? name,
}) {
  factory fromJson(Map<String, dynamic> json) => _$ChampGridChampionFromJson(json);

  Map<String, dynamic> toJson() => _$ChampGridChampionToJson(this);
}

@JsonSerializable()
class SummonerSpell({
  final int? id,
  final String? name,
}) {
  factory fromJson(Map<String, dynamic> json) => _$SummonerSpellFromJson(json);

  Map<String, dynamic> toJson() => _$SummonerSpellToJson(this);
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

@JsonSerializable()
class LobbyDetails({
  required final LobbyGameConfig gameConfig,
  final LobbyMember? localMember,
}) {
  factory fromJson(Map<String, dynamic> json) => _$LobbyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyDetailsToJson(this);
}

@JsonSerializable()
class LobbyMember({
  @JsonKey(readValue: normalizePositionPreference)
  required final LobbyPositionPreference firstPositionPreference,
  @JsonKey(readValue: normalizePositionPreference)
  required final LobbyPositionPreference secondPositionPreference,
}) {
  factory fromJson(Map<String, dynamic> json) => _$LobbyMemberFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyMemberToJson(this);
}

@JsonSerializable()
class LobbyGameConfig({
  required final int queueId,
  required final bool showPositionSelector,
}) {
  factory fromJson(Map<String, dynamic> json) => _$LobbyGameConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyGameConfigToJson(this);
}

@JsonSerializable()
class LobbyPositionPreferences({
  @JsonKey(readValue: normalizePositionPreference)
  required final LobbyPositionPreference firstPreference,
  @JsonKey(readValue: normalizePositionPreference)
  required final LobbyPositionPreference secondPreference,
}) {
  factory fromJson(Map<String, dynamic> json) => _$LobbyPositionPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyPositionPreferencesToJson(this);
}

@JsonEnum(fieldRename: .screamingSnake)
enum LobbyPositionPreference { unselected, fill, top, jungle, middle, bottom, utility }

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
