// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogRecord _$LogRecordFromJson(Map<String, dynamic> json) => LogRecord(
  schemaVersion: (json['schemaVersion'] as num).toInt(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  app: json['app'] as String,
  appVersion: json['appVersion'] as String,
  sessionId: json['sessionId'] as String,
  severity: $enumDecode(_$LogSeverityEnumMap, json['severity']),
  event: json['event'] as String,
  details: json['details'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$LogRecordToJson(LogRecord instance) => <String, dynamic>{
  'schemaVersion': instance.schemaVersion,
  'timestamp': instance.timestamp.toIso8601String(),
  'app': instance.app,
  'appVersion': instance.appVersion,
  'sessionId': instance.sessionId,
  'severity': _$LogSeverityEnumMap[instance.severity]!,
  'event': instance.event,
  'details': ?instance.details,
};

const _$LogSeverityEnumMap = {
  LogSeverity.info: 'info',
  LogSeverity.warning: 'warning',
  LogSeverity.error: 'error',
};
