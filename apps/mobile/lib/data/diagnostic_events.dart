import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';

import 'api_errors.dart';

extension StartupDiagnostics on AppLogger {
  void appStarted() {
    record('app.started', .info);
  }
}

extension DiscoveryDiagnostics on AppLogger {
  void discoveryStarted() {
    record('discovery.started', .info);
  }

  void discoveryCompleted({required bool found}) {
    _recordOutcome('discovery.completed', failure: found ? null : 'not_found');
  }

  void discoveryFailed(Object error) {
    _recordOutcome('discovery.completed', failure: _failureCode(error));
  }
}

extension ConnectionDiagnostics on AppLogger {
  void connectionStarted() {
    record('connection.started', .info);
  }

  void serviceInfoStarted() {
    record('connector.operation.started', .info, details: {'operation': '/service/info'});
  }

  void serviceInfoCompleted([Object? error]) {
    _recordConnectorOperation('/service/info', error);
  }

  void connectionCompleted() {
    _recordOutcome('connection.completed');
  }

  void connectionAddressUnresolved({required bool found}) {
    _recordOutcome(
      'connection.completed',
      failure: found ? 'address_unavailable' : 'not_found',
    );
  }

  void connectionIncompatible() {
    _recordOutcome('connection.completed', failure: 'incompatible_version');
  }

  void connectionFailed(Object error) {
    _recordOutcome('connection.completed', failure: _failureCode(error));
  }
}

extension LiveStatusDiagnostics on AppLogger {
  void statusChanged(RemoteRiftStatusResponse response) {
    final status = switch (response) {
      RemoteRiftData(value: .ready) => 'ready',
      RemoteRiftData(value: .unavailable) => 'game_client_unavailable',
      RemoteRiftError.unableToConnect => 'game_client_connection_failed',
      RemoteRiftError.unknown => 'unknown_error',
    };
    record('status.changed', .info, details: {'status': status});
  }

  void statusInterrupted([Object? error]) {
    record(
      'status.interrupted',
      .warning,
      details: {
        'operation': '/status/watch',
        'failure': error == null ? 'stream_closed' : _failureCode(error),
      },
    );
  }

  void statusRecovered() {
    record('status.recovered', .info, details: {'operation': '/status/watch'});
  }
}

extension GameClientDiagnostics on AppLogger {
  void launchGameClientCompleted(Object? error) {
    _recordConnectorOperation('/game-client/launch', error);
  }
}

extension MatchmakingDiagnostics on AppLogger {
  void createLobbyCompleted(Object? error) {
    _recordConnectorOperation('/lobby/create', error);
  }

  void updateRolePreferencesCompleted(Object? error) {
    _recordConnectorOperation('/lobby/role-preferences', error);
  }

  void leaveLobbyCompleted(Object? error) {
    _recordConnectorOperation('/lobby/leave', error);
  }

  void searchMatchCompleted(Object? error) {
    _recordConnectorOperation('/queue/start', error);
  }

  void stopMatchSearchCompleted(Object? error) {
    _recordConnectorOperation('/queue/stop', error);
  }

  void acceptMatchCompleted(Object? error) {
    _recordConnectorOperation('/queue/accept', error);
  }

  void declineMatchCompleted(Object? error) {
    _recordConnectorOperation('/queue/decline', error);
  }
}

extension ChampionSelectDiagnostics on AppLogger {
  void pickChampionCompleted(Object? error) {
    _recordConnectorOperation('/champ-select/champion', error, action: 'pick');
  }

  void banChampionCompleted(Object? error) {
    _recordConnectorOperation('/champ-select/champion', error, action: 'ban');
  }

  void banNoChampionCompleted(Object? error) {
    _recordConnectorOperation('/champ-select/ban-none', error);
  }

  void changeSummonerSpellCompleted(Object? error) {
    _recordConnectorOperation('/champ-select/spell', error);
  }

  void lockInChampionCompleted(Object? error) {
    _recordConnectorOperation('/champ-select/lock-in', error);
  }
}

extension on AppLogger {
  void _recordConnectorOperation(
    String operation,
    Object? error, {
    String? action,
  }) {
    _recordOutcome(
      'connector.operation.completed',
      failure: error == null ? null : _failureCode(error),
      details: {
        'operation': operation,
        if (action != null) 'action': action,
        if (error case ApiRequestError(:var statusCode)) 'statusCode': statusCode,
      },
    );
  }

  void _recordOutcome(
    String event, {
    String? failure,
    Map<String, Object>? details,
  }) {
    record(
      event,
      failure == null ? .info : .warning,
      details: {
        ...?details,
        'outcome': failure == null ? 'success' : 'failure',
        if (failure != null) 'failure': failure,
      },
    );
  }
}

String _failureCode(Object error) => switch (error) {
  ApiAddressNotSet() => 'address_unavailable',
  ApiConnectionTimeout() || TimeoutException() => 'timeout',
  ApiRequestError() => 'http_error',
  ApiTransportError() || SocketException() || HttpException() || ClientException() => 'transport',
  FormatException() || TypeError() || ArgumentError() => 'invalid_response',
  PlatformException() || MissingPluginException() => 'discovery_unavailable',
  _ => 'unexpected',
};
