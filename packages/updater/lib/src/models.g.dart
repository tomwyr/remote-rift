// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateJournal _$UpdateJournalFromJson(Map<String, dynamic> json) =>
    UpdateJournal(
      version: json['version'] as String,
      backupPath: json['backup_path'] as String,
    );

Map<String, dynamic> _$UpdateJournalToJson(UpdateJournal instance) =>
    <String, dynamic>{
      'version': instance.version,
      'backup_path': instance.backupPath,
    };
