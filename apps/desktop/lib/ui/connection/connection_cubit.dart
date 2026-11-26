import 'dart:async';
import 'dart:ui';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../../services/diagnostic_events.dart';
import 'connection_state.dart';

class ConnectionCubit({
  required final RemoteRiftConnector _connector,
  required final AppLogger _logger,
}) extends Cubit<ConnectionState> {
  this : super(Initial());

  CancelableStream<RemoteRiftStatusResponse>? _statusStream;
  RetryScheduler? _reconnectScheduler;

  void initialize() {
    if (state is! Initial) {
      throw StateError(
        'Tried to initialize while not in initial state (was ${state.runtimeType})',
      );
    }
    _connectToGameClient();
  }

  void reconnect() {
    final connectionError = switch (state) {
      ConnectionError state => state,
      _ => throw StateError(
        'Tried to reconnect while not in error state (was ${state.runtimeType})',
      ),
    };

    final scheduler = _reconnectScheduler;
    if (scheduler == null || scheduler.status == .idle) {
      throw StateError(
        'Reconnect scheduler was not running while in connection error state',
      );
    }

    emit(connectionError.copyWith(reconnectTriggered: true));
    scheduler.trigger();
  }

  void _connectToGameClient() {
    if (state is Connected) {
      _logger.leagueClientDetached();
    }
    emit(Connecting());
    _resetStatusListener();
  }

  Future<void> _reconnectToGameClient() async {
    final completer = Completer<void>();
    _resetStatusListener(onConnectionAttempted: completer.complete);
    await completer.future;
  }

  void _resetStatusListener({VoidCallback? onConnectionAttempted}) {
    _logger.leagueClientConnectionStarted();
    final stream = _connector
        .getStatusStream()
        .peek(
          onFirstOrError: onConnectionAttempted,
          onDone: () {
            _logger.leagueClientStatusInterrupted();
            _connectToGameClient();
          },
        )
        .cancelable();
    _statusStream?.cancel();
    _statusStream = stream;
    _listenStatus(stream);
  }

  void _listenStatus(Stream<RemoteRiftStatusResponse> statusStream) async {
    try {
      await for (var response in statusStream) {
        _logger.statusQueried(response);
        if (state is ConnectionError) {
          _reconnectScheduler?.reset();
        }

        switch (state) {
          case Connecting() || ConnectedWithError() || ConnectionError() || Connected():
            // Can emit from the current state
            break;
          case Initial():
            throw StateError(
              'Tried to update connection status in an unexpected state: ${state.runtimeType}',
            );
        }

        final next = switch (response) {
          RemoteRiftData(value: .ready) => Connected(),
          RemoteRiftData(value: .unavailable) => Connecting(),
          RemoteRiftError error => ConnectedWithError(cause: error),
        };

        _logStatusChange(response, next);
        emit(next);
      }
    } catch (error) {
      _logStatusError(error);
      if (state case Connecting() || Connected()) {
        _initReconnectScheduler();
      }
      emit(ConnectionError());
    }
  }

  void _logStatusChange(RemoteRiftStatusResponse response, ConnectionState next) {
    final previous = state;
    if (previous == next) return;

    _logger.leagueClientStatusChanged(response);
    switch ((previous, next)) {
      case (Connected(), _):
        _logger.leagueClientDetached();
      case (_, Connected()):
        _logger.leagueClientAttached();
      default:
        break;
    }
  }

  void _logStatusError(Object error) {
    _logger.leagueClientStatusInterrupted(error);
    if (state is Connected) {
      _logger.leagueClientDetached();
    }
  }

  void _initReconnectScheduler() {
    _reconnectScheduler = RetryScheduler(
      backoff: .standard,
      onRetry: _reconnectToGameClient,
    )..start();
  }

  @override
  Future<void> close() {
    _statusStream?.cancel();
    _reconnectScheduler?.reset();
    return super.close();
  }
}
