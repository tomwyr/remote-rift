import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';
import 'package:web_socket_channel/io.dart';

class RemoteRiftApiClient.withClients({
  required final Client _httpClient,
  required final HttpClient _webSocketClient,
}) {
  factory({required HttpClient client}) => .withClients(
    httpClient: IOClient(client),
    webSocketClient: client,
  );

  String? _apiAddress;
  void setApiAddress(String? value) {
    _apiAddress = value;
  }

  Future<RemoteRiftApiServiceInfo> getServiceInfo() async {
    final url = '${await _httpBaseUrl}/service/info';
    final response = await _httpClient.get(.parse(url));
    return .fromJson(jsonDecode(response.body));
  }

  Stream<RemoteRiftResponse<RemoteRiftStatus>> getStatusStream({Duration? timeLimit}) async* {
    final url = '${await _webSocketBaseUrl}/status/watch';
    final ws = IOWebSocketChannel.connect(Uri.parse(url), customClient: _webSocketClient);
    final stream = _applyTimeLimit(ws.stream, timeLimit);
    await for (var message in stream) {
      yield .fromJson(jsonDecode(message), RemoteRiftStatus.fromJson);
    }
  }

  Stream<RemoteRiftSession> getCurrentSessionStream() async* {
    final url = '${await _webSocketBaseUrl}/session/watch';
    final ws = IOWebSocketChannel.connect(Uri.parse(url), customClient: _webSocketClient);
    await for (var message in ws.stream) {
      yield .fromJson(jsonDecode(message));
    }
  }

  Future<void> createLobby({required int queueId}) async {
    final url = '${await _httpBaseUrl}/lobby/create?queueId=$queueId';
    await _post(.parse(url));
  }

  Future<void> leaveLobby() async {
    final url = '${await _httpBaseUrl}/lobby/leave';
    await _post(.parse(url));
  }

  Future<void> updateLobbyRolePreferences({
    required LobbyRole first,
    required LobbyRole second,
  }) async {
    final baseUrl = await _httpBaseUrl;
    final input = RolePreferenceInput(first: first, second: second);
    final url = Uri.parse('$baseUrl/lobby/role-preferences');
    await _post(url, body: jsonEncode(input.toJson()));
  }

  Future<void> searchMatch() async {
    final url = '${await _httpBaseUrl}/queue/start';
    await _post(.parse(url));
  }

  Future<void> stopMatchSearch() async {
    final url = '${await _httpBaseUrl}/queue/stop';
    await _post(.parse(url));
  }

  Future<void> acceptMatch() async {
    final url = '${await _httpBaseUrl}/queue/accept';
    await _post(.parse(url));
  }

  Future<void> declineMatch() async {
    final url = '${await _httpBaseUrl}/queue/decline';
    await _post(.parse(url));
  }

  Future<ChampionSelectCatalog> getChampSelectCatalog() async {
    final url = '${await _httpBaseUrl}/champ-select/catalog';
    final response = await _get(.parse(url));
    return .fromJson(jsonDecode(response.body));
  }

  Future<void> pickChampion({required int championId}) => _postChampSelect(
    'champion',
    ChampionSelectChampionInput(
      championId: championId,
      action: .pick,
    ).toJson(),
  );

  Future<void> banChampion({required int championId}) => _postChampSelect(
    'champion',
    ChampionSelectChampionInput(
      championId: championId,
      action: .ban,
    ).toJson(),
  );

  Future<void> lockInChampion() => _postChampSelect('lock-in');

  Future<void> changeSummonerSpell({
    required int spellId,
    required ChampionSelectSummonerSpellSlot slot,
  }) => _postChampSelect(
    'spell',
    ChangeSummonerSpellInput(spellId: spellId, slot: slot).toJson(),
  );

  Future<void> _postChampSelect(String route, [Map<String, dynamic>? body]) async {
    final url = '${await _httpBaseUrl}/champ-select/$route';
    await _post(.parse(url), body: body == null ? null : jsonEncode(body));
  }

  Future<String> get _httpBaseUrl async {
    final apiAddress = await _requireApiAddres();
    return 'http://$apiAddress';
  }

  Future<String> get _webSocketBaseUrl async {
    final apiAddress = await _requireApiAddres();
    return 'ws://$apiAddress';
  }

  Future<String> _requireApiAddres() async {
    if (_apiAddress case var value?) {
      return value;
    } else {
      throw ApiAddressNotSet();
    }
  }

  Stream<T> _applyTimeLimit<T>(Stream<T> stream, Duration? timeLimit) {
    if (timeLimit == null) return stream;

    return stream.timeout(
      timeLimit,
      onTimeout: (sink) {
        sink.addError(ApiConnectionTimeout());
        sink.close();
      },
    );
  }

  Future<Response> _post(Uri url, {String? body}) async {
    return _request(() => _httpClient.post(url, body: body));
  }

  Future<Response> _get(Uri url) async {
    return _request(() => _httpClient.get(url));
  }

  Future<Response> _request(Future<Response> Function() request) async {
    try {
      final response = await request();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiRequestError(response.statusCode);
      }
      return response;
    } on RemoteRiftApiError {
      rethrow;
    } catch (_) {
      throw ApiTransportError();
    }
  }
}

sealed class RemoteRiftApiError implements Exception;

class ApiAddressNotSet extends RemoteRiftApiError;

class ApiConnectionTimeout extends RemoteRiftApiError;

class ApiRequestError(final int statusCode) extends RemoteRiftApiError;

class ApiTransportError extends RemoteRiftApiError;
