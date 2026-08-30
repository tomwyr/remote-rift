import 'github/github_release_mapper.dart';
import 'github/github_releases.dart';
import 'models.dart';

typedef UpdateArtifactNameResolver = String Function(String releaseTag);

class UpdateReleaseCatalog({
  required final GitHubReleases _releases,
  required final String _tagPrefix,
  required final UpdateArtifactNameResolver _resolveArtifactName,
}) {
  Future<UpdateRelease?> getLatest() async {
    final releases = await _releases.getReleases();

    final candidates = <UpdateRelease>[];
    for (final release in releases) {
      final artifactName = _resolveArtifactName(release.tagName);
      final candidate = release.toUpdateRelease(
        tagPrefix: _tagPrefix,
        expectedArtifactName: artifactName,
      );
      if (candidate != null) {
        candidates.add(candidate);
      }
    }

    candidates.sort((a, b) => a.version.isGreaterThan(b.version) ? -1 : 1);
    return candidates.firstOrNull;
  }
}
