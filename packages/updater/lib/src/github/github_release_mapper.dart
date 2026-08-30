import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'github_release_dto.dart';
import '../models.dart';

extension GitHubReleaseMapper on GitHubRelease {
  UpdateRelease? toUpdateRelease({
    required String tagPrefix,
    required String expectedArtifactName,
  }) {
    if (draft || prerelease || !tagName.startsWith(tagPrefix)) {
      return null;
    }
    final version = _parseVersion(tagName.substring(tagPrefix.length));
    if (version == null) {
      return null;
    }
    final artifact = _findArtifact(expectedArtifactName);
    if (artifact == null) {
      return null;
    }
    return UpdateRelease(tag: tagName, version: version, artifact: artifact);
  }

  UpdateArtifact? _findArtifact(String expectedName) {
    for (final asset in assets) {
      if (asset.name != expectedName) {
        continue;
      }
      final downloadUrl = Uri.tryParse(asset.browserDownloadUrl);
      if (downloadUrl == null || downloadUrl.scheme != 'https' || asset.size < 0) {
        return null;
      }
      return UpdateArtifact(
        name: asset.name,
        downloadUrl: downloadUrl,
        size: asset.size,
      );
    }
    return null;
  }

  Version? _parseVersion(String value) {
    if (!RegExp(r'^\d+\.\d+\.\d+$').hasMatch(value)) {
      return null;
    }
    try {
      return Version.parse(value);
    } on VersionError {
      return null;
    }
  }
}
