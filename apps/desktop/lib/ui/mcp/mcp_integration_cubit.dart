import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/app_settings_store.dart';
import '../../services/mcp_server_runner.dart';
import 'mcp_integration_state.dart';

class McpIntegrationCubit({
  required final AppSettingsStore _settingsStore,
  required final McpServerRunner _runner,
}) extends Cubit<McpIntegrationState> {
  this : super(McpIntegrationState(startsOnLaunch: true, status: Idle()));

  final _events = StreamController<McpIntegrationEvent>.broadcast();
  Stream<McpIntegrationEvent> get events => _events.stream;

  void initialize() async {
    try {
      final settings = await _settingsStore.load();
      emit(state.copyWith(startsOnLaunch: settings.mcpStartsOnLaunch));

      if (settings.mcpPreviouslyEnabled && settings.mcpStartsOnLaunch) {
        await _runServer(.start, Starting(), _runner.enable);
      }
    } on AppSettingsError {
      emit(state.copyWith(status: Failed(action: .configuration)));
    }
  }

  void updateStartsOnLaunch(bool startsOnLaunch) async {
    final current = state;

    try {
      await _saveStartsOnLaunch(startsOnLaunch);
      emit(current.copyWith(startsOnLaunch: startsOnLaunch));
    } on AppSettingsError {
      emit(current.copyWith(status: Failed(action: .configuration)));
    }
  }

  void enable() async {
    if (state.status case Starting() || Resetting() || Running()) {
      throw StateError(
        'Tried to enable while already starting or running (was ${state.status.runtimeType})',
      );
    }

    try {
      await _settingsStore.saveMcpPreviouslyEnabled(true);
    } on AppSettingsError {
      emit(state.copyWith(status: Failed(action: .configuration)));
      return;
    }

    await _runServer(.start, Starting(), _runner.enable);
  }

  void disable() async {
    final runningState = _requireRunning();

    try {
      await _settingsStore.saveMcpPreviouslyEnabled(false);
    } on AppSettingsError {
      emit(state.copyWith(status: Failed(action: .configuration)));
      return;
    }

    try {
      await _runner.disable();
      emit(state.copyWith(status: Stopped(lastRunningState: runningState)));
      _events.add(.stopped);
    } catch (_) {
      emit(state.copyWith(status: Failed(action: .stop)));
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
    McpIntegrationStatus pendingStatus,
    Future<McpServerRunInfo> Function() run,
  ) async {
    emit(state.copyWith(status: pendingStatus));
    try {
      final info = await run();
      emit(state.copyWith(status: Running(hostConfiguration: info.hostConfiguration)));
    } catch (_) {
      emit(state.copyWith(status: Failed(action: action)));
    }
  }

  Running _requireRunning() {
    return switch (state.status) {
      Running runningState => runningState,
      _ => throw StateError(
        'Tried to access MCP while not running (was ${state.status.runtimeType})',
      ),
    };
  }

  Future<void> _saveStartsOnLaunch(bool startsOnLaunch) async {
    await _settingsStore.saveMcpStartsOnLaunch(startsOnLaunch);
  }

  @override
  Future<void> close() async {
    await _events.close();
    await _runner.disable();
    await super.close();
  }
}
