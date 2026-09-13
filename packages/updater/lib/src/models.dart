import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

part 'models.g.dart';

class UpdateArtifact({
  required final String name,
  required final Uri downloadUrl,
  required final int size,
}) extends Equatable {
  @override
  List<Object?> get props => [name, downloadUrl, size];
}

class UpdateRelease({
  required final String tag,
  required final Version version,
  required final UpdateArtifact artifact,
}) extends Equatable {
  @override
  List<Object?> get props => [tag, version, artifact];
}

sealed class UpdateStartupResult;

class NoUpdate extends UpdateStartupResult;

class Acknowledged({required final String version}) extends UpdateStartupResult;

class Recovered({required final UpdateRecoveryCause cause}) extends UpdateStartupResult;

class AwaitingAcknowledgement({
  required final String expectedVersion,
  required final String currentVersion,
}) extends UpdateStartupResult;

class InvalidJournal extends UpdateStartupResult;

class InvalidRecovery extends UpdateStartupResult;

@JsonEnum(fieldRename: .snake)
enum UpdateRecoveryCause { invalidArchive, fileSystem, process, unknown }

@JsonSerializable()
class UpdateJournal({
  required final String version,
  required final String backupPath,
}) {
  factory fromJson(Map<String, dynamic> json) => _$UpdateJournalFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateJournalToJson(this);
}

@JsonSerializable()
class UpdateRecoveryRecord({required final UpdateRecoveryCause cause}) {
  factory fromJson(Map<String, dynamic> json) => _$UpdateRecoveryRecordFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateRecoveryRecordToJson(this);
}
