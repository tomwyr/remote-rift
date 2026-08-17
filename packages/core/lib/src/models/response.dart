import 'package:json_annotation/json_annotation.dart';

import 'status.dart';

part 'response.g.dart';

sealed class RemoteRiftResponse<T>() {
  factory fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) dataFromJson,
  ) {
    final type = json['type'];
    return switch (type) {
      'data' => RemoteRiftData(dataFromJson(json)),
      'error' => RemoteRiftError.fromJson(json),
      _ => throw ArgumentError('Unexpected RemoteRiftResponse type $type'),
    };
  }
}

extension RemoteRiftStatusResponseToJson on RemoteRiftResponse<RemoteRiftStatus> {
  Map<String, dynamic> sealedToJson() {
    return switch (this) {
      RemoteRiftData(value: var data) => {'type': 'data', ...data.toJson()},
      RemoteRiftError error => {'type': 'error', ...error.toJson()},
    };
  }
}

class RemoteRiftData<T>(final T value) extends RemoteRiftResponse<T>;

@JsonEnum(alwaysCreate: true)
enum RemoteRiftError<T extends Never> implements RemoteRiftResponse<T> {
  unableToConnect,
  unknown;

  factory fromJson(Map<String, dynamic> json) {
    return $enumDecode(_$RemoteRiftErrorEnumMap, json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'value': _$RemoteRiftErrorEnumMap[this]};
  }
}
