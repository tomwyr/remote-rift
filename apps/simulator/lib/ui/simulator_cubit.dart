import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remote_rift_core/lcu_protocol.dart';

import '../server/simulator_server.dart';
import '../simulation/simulator_queue.dart';
import '../simulation/simulator.dart';
import '../simulation/simulator_stage.dart';
import 'simulator_state.dart';

class SimulatorCubit(final Simulator _simulator) extends Cubit<SimulatorViewState> {
  this : super((connection: Initial(), session: _simulator.snapshot));

  SimulatorServer? _server;
  StreamSubscription<SimulatorSnapshot>? _subscription;
  Future<void>? _startupInFlight;

  void initialize() {
    if (state.connection is Initial) {
      _start();
    }
  }

  void retryStartup() {
    if (state.connection is StartFailed) {
      _start();
    }
  }

  void setOnline(bool online) {
    _simulator.setOnline(online);
  }

  void setDeclineNextMatch(bool decline) {
    _simulator.setDeclineNextMatch(decline);
  }

  void reset() {
    _simulator.reset();
  }

  void createLobby(SimulatorQueue queue) {
    _apply(.home, () => _simulator.createLobby(queue));
  }

  void startSearch() {
    _apply(.lobby, _simulator.startSearch);
  }

  void leaveLobby() {
    _apply(.lobby, _simulator.leaveLobby);
  }

  void stopSearch() {
    _apply(.searching, _simulator.stopSearch);
  }

  void answerReadyCheck(ReadyCheckResponse response) {
    if (_simulator.snapshot.readyCheckResponse != .none) return;
    _apply(.readyCheck, () => _simulator.answerReadyCheck(response));
  }

  void advance(SimulatorStage stage) {
    _apply(stage, _simulator.advance);
  }

  @override
  Future<void> close() async {
    try {
      await _startupInFlight;
      await _subscription?.cancel();
      await _server?.close();
    } finally {
      try {
        await _simulator.close();
      } finally {
        await super.close();
      }
    }
  }

  void _start() async {
    if (_startupInFlight != null) return;
    final startup = _startServer();
    _startupInFlight = startup;
    try {
      await startup;
    } finally {
      _startupInFlight = null;
    }
  }

  Future<void> _startServer() async {
    emit((connection: Starting(), session: _simulator.snapshot));
    try {
      final directory = await getApplicationSupportDirectory();
      final server = await SimulatorServer.start(_simulator, directory);
      _server = server;
      _subscription = _simulator.snapshots.listen(_publishSession);
      emit((
        connection: Listening(lockfilePath: server.lockfilePath),
        session: _simulator.snapshot,
      ));
    } catch (error) {
      final failure = switch (error) {
        MissingPlatformDirectoryException() ||
        PlatformException() ||
        FileSystemException() => SimulatorStartupFailure.lockfileUnavailable,
        SocketException() || TlsException() => SimulatorStartupFailure.listenerUnavailable,
        _ => null,
      };
      if (failure == null) rethrow;

      debugPrint('Simulator startup failed: $error');
      emit((connection: StartFailed(failure: failure), session: _simulator.snapshot));
    }
  }

  void _apply(SimulatorStage stage, void Function() action) {
    final session = _simulator.snapshot;
    if (!session.online || session.stage != stage) return;
    action();
  }

  void _publishSession(SimulatorSnapshot session) {
    emit((connection: state.connection, session: session));
  }
}
