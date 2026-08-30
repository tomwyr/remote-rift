// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreGame _$PreGameFromJson(Map<String, dynamic> json) => PreGame(
  availableQueues: (json['availableQueues'] as List<dynamic>)
      .map((e) => GameQueue.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PreGameToJson(PreGame instance) => <String, dynamic>{
  'availableQueues': instance.availableQueues,
};

Lobby _$LobbyFromJson(Map<String, dynamic> json) => Lobby(
  state: $enumDecode(_$GameLobbyStateEnumMap, json['state']),
  rolePreferences: json['rolePreferences'] == null
      ? null
      : LobbyRolePreferences.fromJson(
          json['rolePreferences'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$LobbyToJson(Lobby instance) => <String, dynamic>{
  'state': _$GameLobbyStateEnumMap[instance.state]!,
  'rolePreferences': instance.rolePreferences,
};

const _$GameLobbyStateEnumMap = {
  GameLobbyState.idle: 'idle',
  GameLobbyState.searching: 'searching',
};

UnselectedLobbyRolePreferences _$UnselectedLobbyRolePreferencesFromJson(
  Map<String, dynamic> json,
) => UnselectedLobbyRolePreferences();

Map<String, dynamic> _$UnselectedLobbyRolePreferencesToJson(
  UnselectedLobbyRolePreferences instance,
) => <String, dynamic>{
  'state': _$LobbyRolePreferencesStateEnumMap[instance.state]!,
};

const _$LobbyRolePreferencesStateEnumMap = {
  LobbyRolePreferencesState.unselected: 'unselected',
  LobbyRolePreferencesState.fill: 'fill',
  LobbyRolePreferencesState.selection: 'selection',
};

FillLobbyRolePreferences _$FillLobbyRolePreferencesFromJson(
  Map<String, dynamic> json,
) => FillLobbyRolePreferences();

Map<String, dynamic> _$FillLobbyRolePreferencesToJson(
  FillLobbyRolePreferences instance,
) => <String, dynamic>{
  'state': _$LobbyRolePreferencesStateEnumMap[instance.state]!,
};

LobbyRoleSelection _$LobbyRoleSelectionFromJson(Map<String, dynamic> json) =>
    LobbyRoleSelection(
      first: $enumDecode(_$LobbyRoleEnumMap, json['first']),
      second: $enumDecode(_$LobbyRoleEnumMap, json['second']),
    );

Map<String, dynamic> _$LobbyRoleSelectionToJson(LobbyRoleSelection instance) =>
    <String, dynamic>{
      'first': _$LobbyRoleEnumMap[instance.first]!,
      'second': _$LobbyRoleEnumMap[instance.second]!,
      'state': _$LobbyRolePreferencesStateEnumMap[instance.state]!,
    };

const _$LobbyRoleEnumMap = {
  LobbyRole.top: 'top',
  LobbyRole.jungle: 'jungle',
  LobbyRole.middle: 'middle',
  LobbyRole.bottom: 'bottom',
  LobbyRole.support: 'support',
};

Found _$FoundFromJson(Map<String, dynamic> json) => Found(
  state: $enumDecode(_$GameFoundStateEnumMap, json['state']),
  answerMaxTime: const DurationSecondsConverter().fromJson(
    (json['answerMaxTime'] as num).toDouble(),
  ),
  answerTimeLeft: const DurationSecondsConverter().fromJson(
    (json['answerTimeLeft'] as num).toDouble(),
  ),
);

Map<String, dynamic> _$FoundToJson(Found instance) => <String, dynamic>{
  'state': _$GameFoundStateEnumMap[instance.state]!,
  'answerMaxTime': const DurationSecondsConverter().toJson(
    instance.answerMaxTime,
  ),
  'answerTimeLeft': const DurationSecondsConverter().toJson(
    instance.answerTimeLeft,
  ),
};

const _$GameFoundStateEnumMap = {
  GameFoundState.pending: 'pending',
  GameFoundState.accepted: 'accepted',
  GameFoundState.declined: 'declined',
};

ChampionSelect _$ChampionSelectFromJson(Map<String, dynamic> json) =>
    ChampionSelect(
      phase: $enumDecode(_$ChampionSelectPhaseEnumMap, json['phase']),
      timeLeft: const DurationMillisecondsConverter().fromJson(
        (json['timeLeft'] as num).toInt(),
      ),
      champion: json['champion'] == null
          ? null
          : Champion.fromJson(json['champion'] as Map<String, dynamic>),
      position: $enumDecodeNullable(
        _$ChampionSelectPositionEnumMap,
        json['position'],
      ),
      spell1: json['spell1'] == null
          ? null
          : SummonerSpell.fromJson(json['spell1'] as Map<String, dynamic>),
      spell2: json['spell2'] == null
          ? null
          : SummonerSpell.fromJson(json['spell2'] as Map<String, dynamic>),
      actionAvailability: ChampionSelectActionAvailability.fromJson(
        json['actionAvailability'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ChampionSelectToJson(
  ChampionSelect instance,
) => <String, dynamic>{
  'phase': _$ChampionSelectPhaseEnumMap[instance.phase]!,
  'timeLeft': const DurationMillisecondsConverter().toJson(instance.timeLeft),
  'champion': instance.champion,
  'position': _$ChampionSelectPositionEnumMap[instance.position],
  'spell1': instance.spell1,
  'spell2': instance.spell2,
  'actionAvailability': instance.actionAvailability,
};

const _$ChampionSelectPhaseEnumMap = {
  ChampionSelectPhase.planning: 'planning',
  ChampionSelectPhase.banPick: 'banPick',
  ChampionSelectPhase.finalization: 'finalization',
};

const _$ChampionSelectPositionEnumMap = {
  ChampionSelectPosition.top: 'top',
  ChampionSelectPosition.jungle: 'jungle',
  ChampionSelectPosition.middle: 'middle',
  ChampionSelectPosition.bottom: 'bottom',
  ChampionSelectPosition.support: 'support',
};

Champion _$ChampionFromJson(Map<String, dynamic> json) =>
    Champion(name: json['name'] as String);

Map<String, dynamic> _$ChampionToJson(Champion instance) => <String, dynamic>{
  'name': instance.name,
};

SummonerSpell _$SummonerSpellFromJson(Map<String, dynamic> json) =>
    SummonerSpell(name: json['name'] as String);

Map<String, dynamic> _$SummonerSpellToJson(SummonerSpell instance) =>
    <String, dynamic>{'name': instance.name};
