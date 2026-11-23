import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart' show WebSocketChannelException;

import 'api_errors.dart';
import 'diagnostic_events.dart';

export 'api_errors.dart';

class RemoteRiftApiClient.withClients({
  required final Client _httpClient,
  required final HttpClient _webSocketClient,
  required final AppLogger _logger,
}) {
  factory({required HttpClient client, required AppLogger logger}) => .withClients(
    httpClient: IOClient(client),
    webSocketClient: client,
    logger: logger,
  );

  String? _apiAddress;

  Future<String> get _httpBaseUrl async {
    final apiAddress = await _requireApiAddres();
    return 'http://$apiAddress';
  }

  Future<String> get _webSocketBaseUrl async {
    final apiAddress = await _requireApiAddres();
    return 'ws://$apiAddress';
  }

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
    final stream = ws.stream.applyTimeLimit(timeLimit).handleErrors();
    await for (var message in stream) {
      yield .fromJson(jsonDecode(message), RemoteRiftStatus.fromJson);
    }
  }

  Stream<RemoteRiftSession> getCurrentSessionStream() async* {
    final url = '${await _webSocketBaseUrl}/session/watch';
    final ws = IOWebSocketChannel.connect(Uri.parse(url), customClient: _webSocketClient);
    final stream = ws.stream.handleErrors();
    await for (var message in stream) {
      yield .fromJson(jsonDecode(message));
    }
  }

  Future<void> launchGameClient() async {
    await _post('/game-client/launch', _logger.launchGameClientCompleted);
  }

  Future<void> createLobby({required int queueId}) async {
    await _post('/lobby/create?queueId=$queueId', _logger.createLobbyCompleted);
  }

  Future<void> updateLobbyRolePreferences({
    required LobbyRole first,
    required LobbyRole second,
  }) async {
    final input = RolePreferenceInput(first: first, second: second);
    await _post(
      '/lobby/role-preferences',
      _logger.updateRolePreferencesCompleted,
      body: jsonEncode(input.toJson()),
    );
  }

  Future<void> leaveLobby() async {
    await _post('/lobby/leave', _logger.leaveLobbyCompleted);
  }

  Future<void> searchMatch() async {
    await _post('/queue/start', _logger.searchMatchCompleted);
  }

  Future<void> stopMatchSearch() async {
    await _post('/queue/stop', _logger.stopMatchSearchCompleted);
  }

  Future<void> acceptMatch() async {
    await _post('/queue/accept', _logger.acceptMatchCompleted);
  }

  Future<void> declineMatch() async {
    await _post('/queue/decline', _logger.declineMatchCompleted);
  }

  Future<ChampionSelectCatalog> getChampSelectCatalog() async {
    final url = '${await _httpBaseUrl}/champ-select/catalog';
    final response = await _get(.parse(url));
    return .fromJson(jsonDecode(response.body));
  }

  Future<void> pickChampion({required int championId}) async {
    final input = ChampionSelectChampionInput(championId: championId, action: .pick);
    await _post(
      '/champ-select/champion',
      _logger.pickChampionCompleted,
      body: jsonEncode(input.toJson()),
    );
  }

  Future<void> banChampion({required int championId}) async {
    final input = ChampionSelectChampionInput(championId: championId, action: .ban);
    await _post(
      '/champ-select/champion',
      _logger.banChampionCompleted,
      body: jsonEncode(input.toJson()),
    );
  }

  Future<void> banNoChampion() async {
    await _post('/champ-select/ban-none', _logger.banNoChampionCompleted);
  }

  Future<void> changeSummonerSpell({
    required int spellId,
    required ChampionSelectSummonerSpellSlot slot,
  }) async {
    final input = ChangeSummonerSpellInput(spellId: spellId, slot: slot);
    await _post(
      '/champ-select/spell',
      _logger.changeSummonerSpellCompleted,
      body: jsonEncode(input.toJson()),
    );
  }

  Future<void> lockInChampion() async {
    await _post('/champ-select/lock-in', _logger.lockInChampionCompleted);
  }

  Future<void> _post(String route, void Function(Object?) recordCompletion, {String? body}) async {
    try {
      final url = Uri.parse('${await _httpBaseUrl}$route');
      await _request(() => _httpClient.post(url, body: body));
    } catch (error) {
      recordCompletion(error);
      rethrow;
    }
    recordCompletion(null);
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

  Future<String> _requireApiAddres() async {
    if (_apiAddress case var value?) {
      return value;
    } else {
      throw ApiAddressNotSet();
    }
  }
}

extension<T> on Stream<T> {
  Stream<T> applyTimeLimit(Duration? timeLimit) {
    if (timeLimit == null) return this;

    return timeout(
      timeLimit,
      onTimeout: (sink) {
        sink.addError(ApiConnectionTimeout());
        sink.close();
      },
    );
  }

  Stream<T> handleErrors() {
    return handleError((error, stackTrace) {
      if (error is WebSocketChannelException) {
        throw ApiTransportError();
      }
      Error.throwWithStackTrace(error, stackTrace);
    });
  }
}
