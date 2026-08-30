// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_preference_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolePreferenceInput _$RolePreferenceInputFromJson(Map<String, dynamic> json) =>
    RolePreferenceInput(
      first: $enumDecode(_$LobbyRoleEnumMap, json['first']),
      second: $enumDecode(_$LobbyRoleEnumMap, json['second']),
    );

Map<String, dynamic> _$RolePreferenceInputToJson(
  RolePreferenceInput instance,
) => <String, dynamic>{
  'first': _$LobbyRoleEnumMap[instance.first]!,
  'second': _$LobbyRoleEnumMap[instance.second]!,
};

const _$LobbyRoleEnumMap = {
  LobbyRole.top: 'top',
  LobbyRole.jungle: 'jungle',
  LobbyRole.middle: 'middle',
  LobbyRole.bottom: 'bottom',
  LobbyRole.support: 'support',
};
