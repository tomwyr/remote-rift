import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:remote_rift_updater/src/github/github_release_dto.dart';
import 'package:remote_rift_updater/src/github/github_releases.dart';
import 'package:test/test.dart';

void main() {
  test('requests release metadata page', () async {
    Uri? requestedUri;
    final updater = releases(
      MockClient((request) async {
        requestedUri = request.url;
        return Response(jsonEncode(_releasesPayload), HttpStatus.ok);
      }),
    );

    await updater.getReleases();

    if (requestedUri case var uri?) {
      expect(uri.queryParameters['per_page'], '100');
    } else {
      fail('Expected a GitHub releases request.');
    }
  });

  test('decodes release metadata', () async {
    final updater = releases(
      MockClient((_) async => Response(jsonEncode(_releasesPayload), HttpStatus.ok)),
    );

    final fetchedReleases = await updater.getReleases();

    expect(fetchedReleases, [
      GitHubRelease(
        tagName: 'desktop-1.2.3',
        draft: false,
        prerelease: false,
        assets: [
          GitHubReleaseAsset(
            name: 'RemoteRift-desktop-1.2.3-macos.zip',
            browserDownloadUrl: 'https://example.com/desktop-1.2.3.zip',
            size: 3,
          ),
        ],
      ),
      GitHubRelease(
        tagName: 'desktop-1.3.0',
        draft: true,
        prerelease: true,
        assets: [
          GitHubReleaseAsset(
            name: 'RemoteRift-desktop-1.3.0-macos.zip',
            browserDownloadUrl: 'https://example.com/desktop-1.3.0.zip',
            size: 17,
          ),
        ],
      ),
    ]);
  });

  test('reports an unavailable GitHub API response', () async {
    final updater = releases(
      MockClient(
        (_) async => Response('', HttpStatus.serviceUnavailable),
      ),
    );

    expect(updater.getReleases(), throwsA(isA<GitHubReleaseError>()));
  });

  for (final failure in [
    SocketException('Network unavailable.'),
    ClientException('Request failed.'),
  ]) {
    test('reports a request failure for ${failure.runtimeType}', () async {
      final updater = releases(
        MockClient((_) async => throw failure),
      );

      expect(updater.getReleases(), throwsA(GitHubReleaseError.requestFailed));
    });
  }

  for (final body in ['not JSON', '{}']) {
    test('reports an invalid GitHub API response for $body', () async {
      final updater = releases(
        MockClient((_) async => Response(body, HttpStatus.ok)),
      );

      expect(updater.getReleases(), throwsA(GitHubReleaseError.invalidResponse));
    });
  }
}

GitHubReleases releases(MockClient client) => GitHubReleases(
  repoName: 'remote-rift',
  userName: 'tomwyr',
  client: client,
);

const _releasesPayload = [
  {
    'tag_name': 'desktop-1.2.3',
    'draft': false,
    'prerelease': false,
    'assets': [
      {
        'name': 'RemoteRift-desktop-1.2.3-macos.zip',
        'browser_download_url': 'https://example.com/desktop-1.2.3.zip',
        'size': 3,
      },
    ],
  },
  {
    'tag_name': 'desktop-1.3.0',
    'draft': true,
    'prerelease': true,
    'assets': [
      {
        'name': 'RemoteRift-desktop-1.3.0-macos.zip',
        'browser_download_url': 'https://example.com/desktop-1.3.0.zip',
        'size': 17,
      },
    ],
  },
];
