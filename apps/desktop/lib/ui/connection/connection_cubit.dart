import 'dart:async';
import 'dart:ui';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'connection_state.dart';

class ConnectionCubit({
  required final RemoteRiftConnector _connector,
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
    emit(Connecting());
    _resetStatusListener();
  }

  Future<void> _reconnectToGameClient() async {
    final completer = Completer<void>();
    _resetStatusListener(onConnectionAttempted: completer.complete);
    await completer.future;
  }

  void _resetStatusListener({VoidCallback? onConnectionAttempted}) {
    final stream = _connector
        .getStatusStream()
        .peek(
          onFirstOrError: onConnectionAttempted,
          onDone: _connectToGameClient,
        )
        .cancelable();
    _statusStream?.cancel();
    _statusStream = stream;
    _listenStatus(stream);
  }

  void _listenStatus(Stream<RemoteRiftStatusResponse> statusStream) async {
    try {
      await for (var response in statusStream) {
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

        switch (response) {
          case RemoteRiftData(value: .ready):
            emit(Connected());

          case RemoteRiftData(value: .unavailable):
            emit(Connecting());

          case RemoteRiftError error:
            emit(ConnectedWithError(cause: error));
        }
      }
    } catch (_) {
      if (state case Connecting() || Connected()) {
        _initReconnectScheduler();
      }
      emit(ConnectionError());
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
