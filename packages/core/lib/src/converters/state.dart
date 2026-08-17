import 'package:json_annotation/json_annotation.dart';

import '../models/state.dart';

class const RemoteRiftStateConverter()
    extends JsonConverter<RemoteRiftState, Map<String, dynamic>> {
  @override
  RemoteRiftState fromJson(Map<String, dynamic> json) {
    return .fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(RemoteRiftState object) {
    return object.sealedToJson();
  }
}
