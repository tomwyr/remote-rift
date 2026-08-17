import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'queue.dart';

part 'state.g.dart';

sealed class const RemoteRiftState() extends Equatable {
  factory fromJson(Map<String, dynamic> json) {
    final type = json['value'];
    return switch (type) {
      'preGame' => PreGame.fromJson(json),
      'lobby' => Lobby.fromJson(json),
      'found' => Found.fromJson(json),
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
}) extends RemoteRiftState {
  factory fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyToJson(this);

  @override
  List<Object?> get props => [state];
}

@JsonSerializable()
class const Found({
  required final GameFoundState state,
  required final double answerMaxTime,
  required final double answerTimeLeft,
}) extends RemoteRiftState {
  factory fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);

  Map<String, dynamic> toJson() => _$FoundToJson(this);

  @override
  List<Object?> get props => [state];
}

class InGame extends RemoteRiftState;

class Unknown extends RemoteRiftState;

enum GameLobbyState { idle, searching }

enum GameFoundState { pending, accepted, declined }
