import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'state.dart';

part 'role_preference_input.g.dart';

@JsonSerializable()
class RolePreferenceInput({
  required final LobbyRole first,
  required final LobbyRole second,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$RolePreferenceInputFromJson(json);

  Map<String, dynamic> toJson() => _$RolePreferenceInputToJson(this);

  @override
  List<Object?> get props => [first, second];
}
