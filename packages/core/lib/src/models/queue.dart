import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'queue.g.dart';

@JsonSerializable()
class GameQueue({
  required final int id,
  required final String name,
  required final bool enabled,
  required final GameQueueCategory category,
  required final GameQueueGroup group,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$GameQueueFromJson(json);

  Map<String, dynamic> toJson() => _$GameQueueToJson(this);

  @override
  List<Object?> get props => [id, name, enabled];
}

enum GameQueueCategory { pvp, ai, other }

enum GameQueueGroup {
  summonersRift,
  aram,
  alternative,
  other;

  int get orderRank => values.indexOf(this) + 1;
}
