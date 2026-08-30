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

@JsonSerializable()
class UpdateJournal({
  required final String version,
  required final String backupPath,
}) {
  factory fromJson(Map<String, dynamic> json) => _$UpdateJournalFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateJournalToJson(this);
}
