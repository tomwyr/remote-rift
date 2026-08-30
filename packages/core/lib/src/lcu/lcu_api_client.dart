import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'lcu_connection.dart';
import 'lcu_models.dart';

class LcuApiClient({
  required final LcuConnection _lcuConnection,
  required final Client _httpClient,
}) {
  Future<HeartbeatConnection> getHeartbeatConnection() async {
    final response = await _request(.post, 'lol-heartbeat/v1/connection-status');
    return .fromJson(jsonDecode(response.body));
  }

  Future<GameflowPhase> getGameflowPhase() async {
    final response = await _request(.get, 'lol-gameflow/v1/gameflow-phase');
    return .fromJson(jsonDecode(response.body));
  }

  Future<GameflowSession> getGameflowSession() async {
    final response = await _request(.get, 'lol-gameflow/v1/session');
    return .fromJson(jsonDecode(response.body));
  }

  Future<ChampSelectSession> getChampSelectSession() async {
    final response = await _request(.get, 'lol-champ-select/v1/session');
    return .fromJson(jsonDecode(response.body));
  }

  Future<List<ChampGridChampion>> getChampGridChampions() async {
    final response = await _request(.get, 'lol-champ-select/v1/all-grid-champions');
    return _listFromJson(jsonDecode(response.body), ChampGridChampion.fromJson);
  }

  Future<List<SummonerSpell>> getSummonerSpells() async {
    final response = await _request(.get, 'lol-game-data/assets/v1/summoner-spells.json');
    return _listFromJson(jsonDecode(response.body), SummonerSpell.fromJson);
  }

  Future<void> updateChampSelectAction({
    required int actionId,
    required ChampSelectActionUpdate update,
  }) async {
    final response = await _request(
      .patch,
      'lol-champ-select/v1/session/actions/$actionId',
      update.toJson(),
    );
    if (!response.isSuccessful) {
      throw LcuApiClientError.requestRejected;
    }
  }

  Future<void> updateMyChampSelectSelection(ChampSelectMySelectionUpdate update) async {
    final response = await _request(
      .patch,
      'lol-champ-select/v1/session/my-selection',
      update.toJson(),
    );
    if (!response.isSuccessful) {
      throw LcuApiClientError.requestRejected;
    }
  }

  Future<List<GameQueue>> getGameQueues() async {
    final response = await _request(.get, 'lol-game-queues/v1/queues');
    return _listFromJson(jsonDecode(response.body), GameQueue.fromJson);
  }

  Future<LobbyDetails> getLobby() async {
    final response = await _request(.get, 'lol-lobby/v2/lobby');
    return .fromJson(jsonDecode(response.body));
  }

  Future<LobbyPositionPreferences> getLocalMemberPositionPreferences() async {
    final response = await _request(
      .get,
      'lol-lobby/v2/lobby/members/localMember/position-preferences',
    );
    return .fromJson(jsonDecode(response.body));
  }

  Future<void> updateLocalMemberPositionPreferences(LobbyPositionPreferences preferences) async {
    final response = await _request(
      .put,
      'lol-lobby/v2/lobby/members/localMember/position-preferences',
      preferences.toJson(),
    );
    if (!response.isSuccessful) throw LcuApiClientError.requestRejected;
  }

  Future<void> createLobby({required int queueId}) async {
    await _requestSuccess(.post, 'lol-lobby/v2/lobby', {'queueId': queueId});
  }

  Future<void> deleteLobby() async {
    await _requestSuccess(.delete, 'lol-lobby/v2/lobby');
  }

  Future<MatchmakingSearch> getMatchmakingSearch() async {
    final response = await _request(.get, 'lol-lobby/v2/lobby/matchmaking/search-state');
    return .fromJson(jsonDecode(response.body));
  }

  Future<void> startMatchmakingSearch() async {
    await _requestSuccess(.post, 'lol-lobby/v2/lobby/matchmaking/search');
  }

  Future<void> stopMatchmakingSearch() async {
    await _requestSuccess(.delete, 'lol-lobby/v2/lobby/matchmaking/search');
  }

  Future<ReadyCheck> getReadyCheck() async {
    final response = await _request(.get, 'lol-matchmaking/v1/ready-check');
    if (response.isSuccessful) {
      return .fromJson(jsonDecode(response.body));
    } else {
      throw ReadyCheckError.fromJson(jsonDecode(response.body));
    }
  }

  Future<void> acceptReadyCheck() async {
    await _requestSuccess(.post, 'lol-matchmaking/v1/ready-check/accept');
  }

  Future<void> declineReadyCheck() async {
    await _requestSuccess(.post, 'lol-matchmaking/v1/ready-check/decline');
  }

  Future<void> _requestSuccess(
    HttpMethod method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    if (!(await _request(method, path, body)).isSuccessful) {
      throw LcuApiClientError.requestRejected;
    }
  }

  Future<Response> _request(HttpMethod method, String path, [Map<String, dynamic>? body]) async {
    Future<Response> execute() async {
      final lockfileData = _lcuConnection.getLockfileData();
      return await _runRequest(method, path, body, lockfileData);
    }

    try {
      return await execute();
    } on SocketException catch (_) {
      // Retry once in case the error was caused by a stale lockfile.
      _lcuConnection.refreshLockfileData();
      try {
        return await execute();
      } on SocketException catch (_) {
        throw LcuApiClientError.unreachable;
      }
    } on ClientException catch (_) {
      throw LcuApiClientError.connectionLost;
    }
  }

  Future<Response> _runRequest(
    HttpMethod method,
    String path,
    Map<String, dynamic>? body,
    LcuLockfileData lockfileData,
  ) async {
    final baseUrl = 'https://127.0.0.1:${lockfileData.port}';
    final url = Uri.parse('$baseUrl/$path');

    final credentials = 'riot:${lockfileData.password}';
    final authorization = base64Encode(utf8.encode(credentials));

    final headers = {'Authorization': 'Basic $authorization', 'Content-Type': 'application/json'};

    return await switch (method) {
      .get => _httpClient.get(url, headers: headers),
      .post => _httpClient.post(url, headers: headers, body: jsonEncode(body)),
      .put => _httpClient.put(url, headers: headers, body: jsonEncode(body)),
      .patch => _httpClient.patch(url, headers: headers, body: jsonEncode(body)),
      .delete => _httpClient.delete(url, headers: headers),
    };
  }

  List<T> _listFromJson<T>(dynamic json, T Function(Map<String, dynamic> json) fromJson) {
    return (json as List).cast<Map<String, dynamic>>().map(fromJson).toList();
  }
}

enum HttpMethod { get, post, put, patch, delete }

extension on Response {
  bool get isSuccessful {
    return statusCode >= 200 && statusCode < 300;
  }
}

enum LcuApiClientError implements Exception { unreachable, connectionLost, requestRejected }
