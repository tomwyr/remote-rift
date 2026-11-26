import 'dart:async';
import 'dart:io';

import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';

extension StartupDiagnostics on AppLogger {
  void appStarted() {
    record('app.started', .info);
  }
}

extension LeagueClientDiagnostics on AppLogger {
  void leagueClientConnectionStarted() {
    record('league_client.connection.started', .info);
  }

  void statusQueried(RemoteRiftStatusResponse response) {
    final status = response.statusCode;
    final failure = response is RemoteRiftError ? status : null;
    recordOutcome(
      'league_client.status.query.completed',
      failure: failure,
      details: {if (failure == null) 'status': status},
    );
  }

  void leagueClientStatusChanged(RemoteRiftStatusResponse response) {
    final status = response.statusCode;
    record('league_client.status.changed', .info, details: {'status': status});
  }

  void leagueClientAttached() {
    record('league_client.attached', .info);
  }

  void leagueClientDetached() {
    record('league_client.detached', .info);
  }

  void leagueClientStatusInterrupted([Object? error]) {
    final failure = error?.failureCode ?? 'stream_closed';
    record('league_client.status.interrupted', .warning, details: {'failure': failure});
  }
}

extension ConnectorServiceDiagnostics on AppLogger {
  void connectorServiceStarting() {
    record('connector.service.starting', .info);
  }

  void connectorServiceStartCompleted([Object? error]) {
    recordOutcome(
      'connector.service.start.completed',
      failure: error?.failureCode,
    );
  }

  Future<void> connectorServiceStopCompleted(Object? error) {
    return recordOutcome(
      'connector.service.stop.completed',
      failure: error?.failureCode,
    );
  }
}

extension ConnectorOperationDiagnostics on AppLogger {
  void connectorOperationFailed(String operation, int statusCode, Object? error) {
    final failure = error?.failureCode ?? 'http_error';
    recordOutcome(
      'connector.operation.completed',
      failure: failure,
      details: {'operation': operation, 'statusCode': statusCode},
    );
  }
}

extension on AppLogger {
  Future<void> recordOutcome(
    String event, {
    String? failure,
    Map<String, Object>? details,
  }) {
    return record(
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

extension on RemoteRiftStatusResponse {
  String get statusCode => switch (this) {
    RemoteRiftData(value: .ready) => 'ready',
    RemoteRiftData(value: .unavailable) => 'game_client_unavailable',
    RemoteRiftError.unableToConnect => 'game_client_connection_failed',
    RemoteRiftError.unknown => 'unknown_error',
  };
}

extension on Object {
  String get failureCode => switch (this) {
    LcuConnectionError() => 'game_client_connection_failed',
    RemoteRiftStateError() => 'operation_rejected',
    GameClientLaunchError() => 'game_client_launch_failed',
    SocketException() || HttpException() => 'transport',
    TimeoutException() => 'timeout',
    FormatException() || TypeError() || ArgumentError() => 'invalid_response',
    _ => 'unexpected',
  };
}
