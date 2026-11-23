import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'log_record.g.dart';

@JsonSerializable(includeIfNull: false)
class LogRecord({
  required final int schemaVersion,
  required final DateTime timestamp,
  required final String app,
  required final String appVersion,
  required final String sessionId,
  required final LogSeverity severity,
  required final String event,
  required final Map<String, Object?>? details,
}) {
  factory fromJson(Map<String, dynamic> json) => _$LogRecordFromJson(json);

  Map<String, dynamic> toJson() => _$LogRecordToJson(this);

  List<int> encodeLine() {
    final json = jsonEncode(toJson());
    return utf8.encode('$json\n');
  }
}

@JsonEnum(fieldRename: .snake)
enum LogSeverity { info, warning, error }
