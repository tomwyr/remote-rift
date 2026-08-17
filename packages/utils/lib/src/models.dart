import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class RemoteRiftApiServiceInfo({
  required final String version,
}) {
  factory fromJson(Map<String, dynamic> json) => _$RemoteRiftApiServiceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteRiftApiServiceInfoToJson(this);
}
