import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'github_release_dto.g.dart';

@JsonSerializable()
class GitHubRelease({
  required final String tagName,
  required final bool draft,
  required final bool prerelease,
  required final List<GitHubReleaseAsset> assets,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$GitHubReleaseFromJson(json);

  Map<String, dynamic> toJson() => _$GitHubReleaseToJson(this);

  @override
  List<Object?> get props => [tagName, draft, prerelease, assets];
}

@JsonSerializable()
class GitHubReleaseAsset({
  required final String name,
  required final String browserDownloadUrl,
  required final int size,
}) extends Equatable {
  factory fromJson(Map<String, dynamic> json) => _$GitHubReleaseAssetFromJson(json);

  Map<String, dynamic> toJson() => _$GitHubReleaseAssetToJson(this);

  @override
  List<Object?> get props => [name, browserDownloadUrl, size];
}
