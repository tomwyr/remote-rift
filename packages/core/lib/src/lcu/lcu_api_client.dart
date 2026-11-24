import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:time/time.dart';

import 'lcu_connection.dart';
import 'lcu_models.dart';
import 'lcu_routes.dart';
import 'lcu_simulator_protocol.dart';

class LcuApiClient({
  required final LcuConnection _lcuConnection,
  required final Client _httpClient,
}) {
  static final _requestTimeout = 5.seconds;

  Future<void> launchSimulator() async {
    await _request(.post, LcuSimulatorProtocol.launchPath);
  }

  Future<HeartbeatConnection> getHeartbeatConnection() async {
    return _requestJson(
      .post,
      LcuRoutes.heartbeat,
      decode: (json) => .fromJson(json),
    );
  }

  Future<GameflowPhase> getGameflowPhase() async {
    return _requestJson(
      .get,
      LcuRoutes.gameflowPhase,
      decode: (json) => .fromJson(json),
    );
  }

  Future<GameflowSession> getGameflowSession() async {
    return _requestJson(
      .get,
      LcuRoutes.gameflowSession,
      decode: (json) => .fromJson(json),
    );
  }

  Future<List<GameQueue>> getGameQueues() async {
    return _requestJsonList(
      .get,
      LcuRoutes.queues,
      decode: (json) => .fromJson(json),
    );
  }

  Future<LobbyDetails?> getLobby() async {
    return _requestJson(
      .get,
      LcuRoutes.lobby,
      decode: (json) => .fromJson(json),
    );
  }

  Future<LobbyPositionPreferences> getLocalMemberPositionPreferences() async {
    return _requestJson(
      .get,
      LcuRoutes.lobbyPositionPreferences,
      decode: (json) => .fromJson(json),
    );
  }

  Future<void> updateLocalMemberPositionPreferences(LobbyPositionPreferences preferences) async {
    await _request(
      .put,
      LcuRoutes.lobbyPositionPreferences,
      preferences.toJson(),
    );
  }

  Future<void> createLobby({required int queueId}) async {
    final request = LobbyCreateRequest(queueId: queueId);
    await _request(.post, LcuRoutes.lobby, request.toJson());
  }

  Future<void> deleteLobby() async {
    await _request(.delete, LcuRoutes.lobby);
  }

  Future<MatchmakingSearch> getMatchmakingSearch() async {
    return _requestJson(
      .get,
      LcuRoutes.matchmakingSearchState,
      decode: (json) => .fromJson(json),
    );
  }

  Future<void> startMatchmakingSearch() async {
    await _request(.post, LcuRoutes.matchmakingSearch);
  }

  Future<void> stopMatchmakingSearch() async {
    await _request(.delete, LcuRoutes.matchmakingSearch);
  }

  Future<ReadyCheck> getReadyCheck() async {
    return _requestJson(
      .get,
      LcuRoutes.readyCheck,
      decode: (json) => .fromJson(json),
    );
  }

  Future<void> acceptReadyCheck() async {
    await _request(.post, LcuRoutes.acceptReadyCheck);
  }

  Future<void> declineReadyCheck() async {
    await _request(.post, LcuRoutes.declineReadyCheck);
  }

  Future<ChampSelectSession> getChampSelectSession() async {
    return _requestJson(
      .get,
      LcuRoutes.championSelectSession,
      decode: (json) => .fromJson(json),
    );
  }

  Future<List<ChampGridChampion>> getChampGridChampions() async {
    return _requestJsonList(
      .get,
      LcuRoutes.championGrid,
      decode: (json) => .fromJson(json),
    );
  }

  Future<List<SummonerSpell>> getSummonerSpells() async {
    return _requestJsonList(
      .get,
      LcuRoutes.summonerSpells,
      decode: (json) => .fromJson(json),
    );
  }

  Future<void> updateChampSelectAction({
    required int actionId,
    required ChampSelectActionUpdate update,
  }) async {
    await _request(
      .patch,
      '${LcuRoutes.championSelectActions}/$actionId',
      update.toJson(),
    );
  }

  Future<void> updateMyChampSelectSelection(ChampSelectMySelectionUpdate update) async {
    await _request(
      .patch,
      LcuRoutes.championSelectLocalSelection,
      update.toJson(),
    );
  }

  Future<T> _requestJson<T>(
    HttpMethod method,
    String path, {
    Map<String, dynamic>? body,
    required T Function(dynamic json) decode,
  }) async {
    final response = await _request(method, path, body);
    return _decode(
      response,
      decode: decode,
    );
  }

  Future<List<T>> _requestJsonList<T>(
    HttpMethod method,
    String path, {
    Map<String, dynamic>? body,
    required T Function(Map<String, dynamic> json) decode,
  }) async {
    final response = await _request(method, path, body);
    return _decode(
      response,
      decode: (json) => _listFromJson(json, decode),
    );
  }

  Future<Response> _request(
    HttpMethod method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final response = await _performRequest(method, path, body);
    if (!response.isSuccessful) {
      throw LcuApiClientError.requestRejected;
    }
    return response;
  }

  Future<Response> _performRequest(
    HttpMethod method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final revision = _lcuConnection.lockfilePathRevision;

    Future<Response> execute() async {
      final lockfileData = await _lcuConnection.getLockfileData();
      _lcuConnection.requireLockfilePathRevision(revision);
      final response = await _runRequest(method, path, body, lockfileData);
      _lcuConnection.requireLockfilePathRevision(revision);
      return response;
    }

    try {
      return await execute();
    } on SocketException catch (_) {
      // Retry once in case the error was caused by a stale lockfile.
      _lcuConnection.requireLockfilePathRevision(revision);
      await _lcuConnection.refreshLockfileData();
      try {
        return await execute();
      } on SocketException catch (_) {
        throw LcuApiClientError.unreachable;
      }
    } catch (error) {
      if (error case ClientException() || IOException() || TimeoutException()) {
        throw LcuApiClientError.connectionLost;
      }
      rethrow;
    }
  }

  Future<Response> _runRequest(
    HttpMethod method,
    String path,
    Map<String, dynamic>? body,
    LcuLockfileData lockfileData,
  ) async {
    final url = Uri.https('127.0.0.1:${lockfileData.port}', path);

    final credentials = 'riot:${lockfileData.password}';
    final authorization = base64Encode(utf8.encode(credentials));

    final headers = {'Authorization': 'Basic $authorization', 'Content-Type': 'application/json'};

    final request = switch (method) {
      .get => _httpClient.get(url, headers: headers),
      .post => _httpClient.post(url, headers: headers, body: jsonEncode(body)),
      .put => _httpClient.put(url, headers: headers, body: jsonEncode(body)),
      .patch => _httpClient.patch(url, headers: headers, body: jsonEncode(body)),
      .delete => _httpClient.delete(url, headers: headers),
    };
    return await request.timeout(_requestTimeout);
  }

  List<T> _listFromJson<T>(dynamic json, T Function(Map<String, dynamic> json) fromJson) {
    return (json as List).cast<Map<String, dynamic>>().map(fromJson).toList();
  }

  T _decode<T>(Response response, {required T Function(dynamic json) decode}) {
    try {
      final json = jsonDecode(response.body);
      if (json != null) {
        return decode(json);
      }
      if (null is! T) {
        throw ArgumentError.value(json, 'json', 'Expected a value');
      }
      return null as T;
    } catch (error) {
      if (error is FormatException || error is ArgumentError || error is TypeError) {
        throw LcuApiClientError.invalidResponse;
      }
      rethrow;
    }
  }
}

enum HttpMethod { get, post, put, patch, delete }

extension on Response {
  bool get isSuccessful {
    return statusCode >= 200 && statusCode < 300;
  }
}

enum LcuApiClientError implements Exception {
  unreachable,
  connectionLost,
  requestRejected,
  invalidResponse,
}
