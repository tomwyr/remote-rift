import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../converters/state.dart';
import 'state.dart';

part 'session.g.dart';

@JsonSerializable()
class RemoteRiftSession({
  required final String? queueName,
  @RemoteRiftStateConverter() required final RemoteRiftState state,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$RemoteRiftSessionFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteRiftSessionToJson(this);

  @override
  List<Object?> get props => [queueName, state];
}
