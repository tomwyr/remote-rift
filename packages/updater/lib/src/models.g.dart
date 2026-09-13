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

UpdateRecoveryRecord _$UpdateRecoveryRecordFromJson(
  Map<String, dynamic> json,
) => UpdateRecoveryRecord(
  cause: $enumDecode(_$UpdateRecoveryCauseEnumMap, json['cause']),
);

Map<String, dynamic> _$UpdateRecoveryRecordToJson(
  UpdateRecoveryRecord instance,
) => <String, dynamic>{'cause': _$UpdateRecoveryCauseEnumMap[instance.cause]!};

const _$UpdateRecoveryCauseEnumMap = {
  UpdateRecoveryCause.invalidArchive: 'invalid_archive',
  UpdateRecoveryCause.fileSystem: 'file_system',
  UpdateRecoveryCause.process: 'process',
  UpdateRecoveryCause.unknown: 'unknown',
};
