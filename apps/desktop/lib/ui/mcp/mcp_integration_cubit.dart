import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/mcp_server_runner.dart';
import 'mcp_integration_state.dart';

class McpIntegrationCubit({required final McpServerRunner _runner})
    extends Cubit<McpIntegrationState> {
  this : super(Idle());

  final _events = StreamController<McpIntegrationEvent>.broadcast();
  Stream<McpIntegrationEvent> get events => _events.stream;

  void enable() async {
    if (state case Starting() || Resetting() || Running()) {
      throw StateError(
        'Tried to enable while already starting or running (was ${state.runtimeType})',
      );
    }

    await _runServer(.start, Starting(), _runner.enable);
  }

  void disable() async {
    final runningState = _requireRunning();

    try {
      await _runner.disable();
      emit(Stopped(lastRunningState: runningState));
      _events.add(.stopped);
    } catch (_) {
      emit(Failed(action: .stop));
    }
  }

  void reset() async {
    final runningState = _requireRunning();

    await _runServer(
      .reset,
      Resetting(lastRunningState: runningState),
      _runner.reset,
    );
  }

  Future<void> _runServer(
    McpAction action,
    McpIntegrationState pendingState,
    Future<McpServerRunInfo> Function() run,
  ) async {
    emit(pendingState);
    try {
      final info = await run();
      emit(Running(hostConfiguration: info.hostConfiguration));
    } catch (_) {
      emit(Failed(action: action));
    }
  }

  Running _requireRunning() {
    return switch (state) {
      Running runningState => runningState,
      _ => throw StateError('Tried to access MCP while not running (was ${state.runtimeType})'),
    };
  }

  @override
  Future<void> close() async {
    await _events.close();
    await _runner.disable();
    await super.close();
  }
}
