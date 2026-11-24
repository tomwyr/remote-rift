import 'dart:async';

import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../data/repository.dart';
import 'handlers.dart';

part 'route_registration.dart';

class ConnectorRoutes(
  final Router _router,
  final RemoteRiftConnector Function() _createConnector,
  final ConnectorFailureObserver? _onFailure,
) {
  static Router configure(
    RemoteRiftConnector Function() createConnector,
    ConnectorFailureObserver? onFailure,
  ) {
    final router = Router();
    ConnectorRoutes(router, createConnector, onFailure)
      ..configureService()
      ..configureGameClient()
      ..configureStatus()
      ..configureSession()
      ..configureLobby()
      ..configureQueue()
      ..configureChampSelect();
    return router;
  }

  void configureService() {
    String route(String value) => '/service/$value';

    _get(route('info'), (request) async {
      final info = await ApiServiceRepository().getServiceInfo();
      return .ok(info.toJson());
    });
  }

  void configureGameClient() {
    _post('/game-client/launch', (request) async {
      await _createConnector().launchGameClient();
      return .noContent();
    });
  }

  void configureStatus() {
    String route(String value) => '/status/$value';

    _mountWs(route('watch'), (webSocket) async {
      final statuses = _createConnector().getStatusStream();
      final updates = statuses.map((status) => status.sealedToJson());
      await webSocket.sendJsonUpdates(updates);
    });
  }

  void configureSession() {
    String route(String value) => '/session/$value';

    _mountWs(route('watch'), (webSocket) async {
      final sessions = _createConnector().getCurrentSessionStream();
      final updates = sessions.map((session) => session.toJson());
      await webSocket.sendJsonUpdates(updates);
    });
  }

  void configureLobby() {
    String route(String value) => '/lobby/$value';

    _post(route('create'), (request) async {
      final queueId = request.intQueryParam('queueId');
      if (queueId == null) return .badRequest();

      await _createConnector().createLobby(queueId: queueId);
      return .noContent();
    });

    _post(route('leave'), (request) async {
      await _createConnector().leaveLobby();
      return .noContent();
    });

    _post(route('role-preferences'), (request) async {
      final input = await request.decodeBodyOrNull(RolePreferenceInput.fromJson);
      if (input == null || input.first == input.second) return .badRequest();

      await _createConnector().updateLobbyRolePreferences(
        first: input.first,
        second: input.second,
      );
      return .noContent();
    });
  }

  void configureQueue() {
    String route(String value) => '/queue/$value';

    _post(route('start'), (request) async {
      await _createConnector().searchMatch();
      return .noContent();
    });

    _post(route('stop'), (request) async {
      await _createConnector().stopMatchSearch();
      return .noContent();
    });

    _post(route('accept'), (request) async {
      await _createConnector().acceptMatch();
      return .noContent();
    });

    _post(route('decline'), (request) async {
      await _createConnector().declineMatch();
      return .noContent();
    });
  }

  void configureChampSelect() {
    String route(String value) => '/champ-select/$value';

    _get(route('catalog'), (request) async {
      final catalog = await _createConnector().getChampionSelectCatalog();
      return .ok(catalog.toJson());
    });

    _post(route('champion'), (request) async {
      final input = await request.decodeBodyOrNull(ChampionSelectChampionInput.fromJson);
      if (input == null || input.championId <= 0) {
        return .badRequest();
      }
      final connector = _createConnector();
      await switch (input.action) {
        .pick => connector.pickChampion(championId: input.championId),
        .ban => connector.banChampion(championId: input.championId),
      };
      return .noContent();
    });

    _post(route('ban-none'), (request) async {
      await _createConnector().banNoChampion();
      return .noContent();
    });

    _post(route('lock-in'), (request) async {
      await _createConnector().lockInChampion();
      return .noContent();
    });

    _post(route('spell'), (request) async {
      final input = await request.decodeBodyOrNull(ChangeSummonerSpellInput.fromJson);
      if (input == null || input.spellId <= 0) {
        return .badRequest();
      }
      await _createConnector().changeSummonerSpell(
        spellId: input.spellId,
        slot: input.slot,
      );
      return .noContent();
    });
  }
}

/// Observes failures using the registered connector operation and HTTP status.
typedef ConnectorFailureObserver = void Function(String operation, int statusCode, Object? error);
