import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../converters/duration.dart';
import 'champ_select_action.dart';
import 'queue.dart';

part 'state.g.dart';

sealed class const RemoteRiftState() extends Equatable {
  factory fromJson(Map<String, dynamic> json) {
    final type = json['value'];
    return switch (type) {
      'preGame' => PreGame.fromJson(json),
      'lobby' => Lobby.fromJson(json),
      'found' => Found.fromJson(json),
      'championSelect' => ChampionSelect.fromJson(json),
      'inGame' => InGame(),
      'unknown' => Unknown(),
      _ => throw ArgumentError('Unexpected RemoteRiftState type $type'),
    };
  }

  Map<String, dynamic> sealedToJson() {
    return switch (this) {
      PreGame object => {'value': 'preGame', ...object.toJson()},
      Lobby object => {'value': 'lobby', ...object.toJson()},
      Found object => {'value': 'found', ...object.toJson()},
      ChampionSelect object => {'value': 'championSelect', ...object.toJson()},
      InGame() => {'value': 'inGame'},
      Unknown() => {'value': 'unknown'},
    };
  }

  @override
  List<Object?> get props => [];
}

@JsonSerializable()
class PreGame({
  required final List<GameQueue> availableQueues,
}) extends RemoteRiftState {
  factory fromJson(Map<String, dynamic> json) => _$PreGameFromJson(json);

  Map<String, dynamic> toJson() => _$PreGameToJson(this);

  @override
  List<Object?> get props => [availableQueues];
}

@JsonSerializable()
class const Lobby({
  required final GameLobbyState state,
  final LobbyRolePreferences? rolePreferences,
}) extends RemoteRiftState {
  factory fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyToJson(this);

  @override
  List<Object?> get props => [state, rolePreferences];
}

sealed class const LobbyRolePreferences() extends Equatable {
  factory fromJson(Map<String, dynamic> json) {
    return switch (json['state']) {
      'unselected' => UnselectedLobbyRolePreferences.fromJson(json),
      'fill' => FillLobbyRolePreferences.fromJson(json),
      'selection' => LobbyRoleSelection.fromJson(json),
      _ => throw ArgumentError('Unexpected LobbyRolePreferences value $json'),
    };
  }

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class const UnselectedLobbyRolePreferences() extends LobbyRolePreferences {
  @JsonKey(includeToJson: true)
  final LobbyRolePreferencesState state = .unselected;

  factory fromJson(Map<String, dynamic> json) => _$UnselectedLobbyRolePreferencesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UnselectedLobbyRolePreferencesToJson(this);

  @override
  List<Object?> get props => [];
}

@JsonSerializable()
class const FillLobbyRolePreferences() extends LobbyRolePreferences {
  @JsonKey(includeToJson: true)
  final LobbyRolePreferencesState state = .fill;

  factory fromJson(Map<String, dynamic> json) => _$FillLobbyRolePreferencesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FillLobbyRolePreferencesToJson(this);

  @override
  List<Object?> get props => [];
}

@JsonSerializable()
class LobbyRoleSelection({
  required final LobbyRole first,
  required final LobbyRole second,
}) extends LobbyRolePreferences {
  @JsonKey(includeToJson: true)
  final LobbyRolePreferencesState state = .selection;

  factory fromJson(Map<String, dynamic> json) => _$LobbyRoleSelectionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LobbyRoleSelectionToJson(this);

  @override
  List<Object?> get props => [first, second];
}

@JsonSerializable()
class Found({
  required final GameFoundState state,
  @DurationSecondsConverter() required final Duration answerMaxTime,
  @DurationSecondsConverter() required final Duration answerTimeLeft,
}) extends RemoteRiftState {
  factory fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);

  Map<String, dynamic> toJson() => _$FoundToJson(this);

  @override
  List<Object?> get props => [state];
}

@JsonSerializable()
class ChampionSelect({
  required final ChampionSelectPhase phase,
  @DurationMillisecondsConverter() required final Duration timeLeft,
  required final Champion? champion,
  required final ChampionSelectPosition? position,
  required final SummonerSpell? spell1,
  required final SummonerSpell? spell2,
  required final ChampionSelectActionAvailability actionAvailability,
}) extends RemoteRiftState {
  factory fromJson(Map<String, dynamic> json) => _$ChampionSelectFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionSelectToJson(this);

  @override
  List<Object?> get props => [
    phase,
    timeLeft,
    champion,
    position,
    spell1,
    spell2,
    actionAvailability,
  ];
}

@JsonSerializable()
class Champion({
  required final String name,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$ChampionFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionToJson(this);

  @override
  List<Object?> get props => [name];
}

@JsonSerializable()
class SummonerSpell({
  required final String name,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$SummonerSpellFromJson(json);

  Map<String, dynamic> toJson() => _$SummonerSpellToJson(this);

  @override
  List<Object?> get props => [name];
}

class InGame extends RemoteRiftState;

class Unknown extends RemoteRiftState;

enum GameLobbyState { idle, searching }

@JsonEnum(fieldRename: .snake)
enum LobbyRolePreferencesState { unselected, fill, selection }

@JsonEnum(fieldRename: .snake)
enum LobbyRole { top, jungle, middle, bottom, support }

enum GameFoundState { pending, accepted, declined }

enum ChampionSelectPhase { planning, banPick, finalization }

enum ChampionSelectPosition { top, jungle, middle, bottom, support }
