import 'dart:convert';
import 'dart:io';

import 'package:application_updater/src/github_releases.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  test('getLatestReleaseTag returns first matching scoped tag', () async {
    final releases = GitHubReleases(
      repoName: 'remote-rift',
      userName: 'tomwyr',
      tagPrefix: 'desktop-',
      resolveArtifactName: (releaseTag) => '$releaseTag.zip',
      client: MockClient((request) async {
        expect(
          request.url.toString(),
          'https://api.github.com/repos/tomwyr/remote-rift/releases',
        );
        return Response(
          jsonEncode([
            {'tag_name': 'mobile-1.3.0'},
            {'tag_name': 'desktop-1.2.3'},
            {'tag_name': 'desktop-1.2.2'},
          ]),
          200,
        );
      }),
    );

    expect(await releases.getLatestReleaseTag(), 'desktop-1.2.3');
  });

  test('getLatestReleaseTag returns null when no scoped tag matches', () async {
    final releases = GitHubReleases(
      repoName: 'remote-rift',
      userName: 'tomwyr',
      tagPrefix: 'desktop-',
      resolveArtifactName: (releaseTag) => '$releaseTag.zip',
      client: MockClient((request) async {
        return Response(
          jsonEncode([
            {'tag_name': 'mobile-1.3.0'},
            {'tag_name': 'connector-1.2.3'},
          ]),
          200,
        );
      }),
    );

    expect(await releases.getLatestReleaseTag(), isNull);
  });

  test('downloadRelease downloads from full scoped tag', () async {
    final releases = GitHubReleases(
      repoName: 'remote-rift',
      userName: 'tomwyr',
      tagPrefix: 'desktop-',
      resolveArtifactName: (releaseTag) => 'RemoteRift-$releaseTag-macos.zip',
      client: MockClient((request) async {
        expect(
          request.url.toString(),
          'https://github.com/tomwyr/remote-rift/releases/download/desktop-1.2.3/'
          'RemoteRift-desktop-1.2.3-macos.zip',
        );
        return Response.bytes([1, 2, 3], 200);
      }),
    );

    final path = await releases.downloadRelease(releaseTag: 'desktop-1.2.3');

    expect(path, isNotNull);
    expect(await File(path!).readAsBytes(), [1, 2, 3]);
  });
}
