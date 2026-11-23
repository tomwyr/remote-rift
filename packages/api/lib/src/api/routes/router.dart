import 'dart:async';

import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../data/repository.dart';
import 'handlers.dart';

part 'route_registration.dart';

class ConnectorRoutes(final Router _router, final ConnectorFailureObserver? _onFailure) {
  static Router configure(ConnectorFailureObserver? onFailure) {
    final router = Router();
    ConnectorRoutes(router, onFailure)
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
      await RemoteRiftConnector().launchGameClient();
      return .noContent();
    });
  }

  void configureStatus() {
    String route(String value) => '/status/$value';

    _mountWs(route('watch'), (webSocket) async {
      await for (var status in RemoteRiftConnector().getStatusStream()) {
        if (webSocket.status == .closed) break;
        webSocket.sink.addJson(status.sealedToJson());
      }
    });
  }

  void configureSession() {
    String route(String value) => '/session/$value';

    _mountWs(route('watch'), (webSocket) async {
      await for (var session in RemoteRiftConnector().getCurrentSessionStream()) {
        if (webSocket.status == .closed) break;
        webSocket.sink.addJson(session.toJson());
      }
    });
  }

  void configureLobby() {
    String route(String value) => '/lobby/$value';

    _post(route('create'), (request) async {
      final queueId = request.intQueryParam('queueId');
      if (queueId == null) return .badRequest();

      await RemoteRiftConnector().createLobby(queueId: queueId);
      return .noContent();
    });

    _post(route('leave'), (request) async {
      await RemoteRiftConnector().leaveLobby();
      return .noContent();
    });

    _post(route('role-preferences'), (request) async {
      final input = await request.decodeBodyOrNull(RolePreferenceInput.fromJson);
      if (input == null || input.first == input.second) return .badRequest();

      await RemoteRiftConnector().updateLobbyRolePreferences(
        first: input.first,
        second: input.second,
      );
      return .noContent();
    });
  }

  void configureQueue() {
    String route(String value) => '/queue/$value';

    _post(route('start'), (request) async {
      await RemoteRiftConnector().searchMatch();
      return .noContent();
    });

    _post(route('stop'), (request) async {
      await RemoteRiftConnector().stopMatchSearch();
      return .noContent();
    });

    _post(route('accept'), (request) async {
      await RemoteRiftConnector().acceptMatch();
      return .noContent();
    });

    _post(route('decline'), (request) async {
      await RemoteRiftConnector().declineMatch();
      return .noContent();
    });
  }

  void configureChampSelect() {
    String route(String value) => '/champ-select/$value';

    _get(route('catalog'), (request) async {
      final catalog = await RemoteRiftConnector().getChampionSelectCatalog();
      return .ok(catalog.toJson());
    });

    _post(route('champion'), (request) async {
      final input = await request.decodeBodyOrNull(ChampionSelectChampionInput.fromJson);
      if (input == null || input.championId <= 0) {
        return .badRequest();
      }
      final connector = RemoteRiftConnector();
      await switch (input.action) {
        .pick => connector.pickChampion(championId: input.championId),
        .ban => connector.banChampion(championId: input.championId),
      };
      return .noContent();
    });

    _post(route('ban-none'), (request) async {
      await RemoteRiftConnector().banNoChampion();
      return .noContent();
    });

    _post(route('lock-in'), (request) async {
      await RemoteRiftConnector().lockInChampion();
      return .noContent();
    });

    _post(route('spell'), (request) async {
      final input = await request.decodeBodyOrNull(ChangeSummonerSpellInput.fromJson);
      if (input == null || input.spellId <= 0) {
        return .badRequest();
      }
      await RemoteRiftConnector().changeSummonerSpell(
        spellId: input.spellId,
        slot: input.slot,
      );
      return .noContent();
    });
  }
}

/// Observes failures using the registered connector operation and HTTP status.
typedef ConnectorFailureObserver = void Function(String operation, int statusCode, Object? error);
