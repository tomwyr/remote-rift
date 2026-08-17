import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

typedef GitHubNameResolver = String Function(String releaseTag);

class GitHubReleases({
  required final String _repoName,
  required final String _userName,
  required final String _tagPrefix,
  required final GitHubNameResolver _resolveArtifactName,
  Client? client,
}) {
  final _client = client ?? Client();

  late final _baseUrl = 'https://github.com/$_userName/$_repoName';
  late final _apiBaseUrl = 'https://api.github.com/repos/$_userName/$_repoName';

  Future<String?> getLatestReleaseTag() async {
    final url = '$_apiBaseUrl/releases';
    final response = await _client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return null;
    }
    final releases = (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
    for (var release in releases) {
      final tagName = release['tag_name'];
      if (tagName case String value when value.startsWith(_tagPrefix)) {
        return value;
      }
    }
    return null;
  }

  Future<String?> downloadRelease({required String releaseTag}) async {
    final artifactName = _resolveArtifactName(releaseTag);
    final url = '$_baseUrl/releases/download/$releaseTag/$artifactName';

    final response = await _client.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return null;
    }

    final downloadPath = join(Directory.systemTemp.path, artifactName);
    await File(downloadPath).writeAsBytes(response.bodyBytes);
    return downloadPath;
  }

  String versionFromTag(String releaseTag) => releaseTag.substring(_tagPrefix.length);
}
