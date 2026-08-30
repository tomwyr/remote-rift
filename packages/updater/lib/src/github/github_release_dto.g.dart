// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_release_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GitHubRelease _$GitHubReleaseFromJson(Map<String, dynamic> json) =>
    GitHubRelease(
      tagName: json['tag_name'] as String,
      draft: json['draft'] as bool,
      prerelease: json['prerelease'] as bool,
      assets: (json['assets'] as List<dynamic>)
          .map((e) => GitHubReleaseAsset.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GitHubReleaseToJson(GitHubRelease instance) =>
    <String, dynamic>{
      'tag_name': instance.tagName,
      'draft': instance.draft,
      'prerelease': instance.prerelease,
      'assets': instance.assets,
    };

GitHubReleaseAsset _$GitHubReleaseAssetFromJson(Map<String, dynamic> json) =>
    GitHubReleaseAsset(
      name: json['name'] as String,
      browserDownloadUrl: json['browser_download_url'] as String,
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$GitHubReleaseAssetToJson(GitHubReleaseAsset instance) =>
    <String, dynamic>{
      'name': instance.name,
      'browser_download_url': instance.browserDownloadUrl,
      'size': instance.size,
    };
