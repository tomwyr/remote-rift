import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:time/time.dart';

import 'github_release_dto.dart';

class GitHubReleases({
  required String repoName,
  required String userName,
  Client? client,
  Duration? requestTimeout,
}) {
  final Client _client = client ?? Client();
  final Duration _requestTimeout = requestTimeout ?? 30.seconds;
  final String _apiBaseUrl = 'https://api.github.com/repos/$userName/$repoName';

  Future<List<GitHubRelease>> getReleases() async {
    final response = await _request(
      () => _client.get(Uri.parse('$_apiBaseUrl/releases?per_page=100')),
    );

    return _decodeList(response, GitHubRelease.fromJson);
  }

  Future<Response> _request(Future<Response> Function() send) async {
    late final Response response;
    try {
      response = await send().timeout(_requestTimeout);
    } catch (error) {
      if (error case SocketException() || TimeoutException() || ClientException()) {
        throw GitHubReleaseError.requestFailed;
      }
      rethrow;
    }
    if (response.statusCode != HttpStatus.ok) {
      throw GitHubReleaseError.requestFailed;
    }

    return response;
  }

  List<T> _decodeList<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final decoded = (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      return decoded.map(fromJson).toList();
    } catch (error) {
      if (error case FormatException() || TypeError()) {
        throw GitHubReleaseError.invalidResponse;
      }
      rethrow;
    }
  }
}

enum GitHubReleaseError implements Exception {
  requestFailed,
  invalidResponse,
}
