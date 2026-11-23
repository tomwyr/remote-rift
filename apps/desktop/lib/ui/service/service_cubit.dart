import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';

import '../../services/api_service_runner.dart';
import '../../services/app_settings_store.dart';
import '../../services/diagnostic_events.dart';
import 'service_state.dart';

class ServiceCubit({
  required final AppSettingsStore _settingsStore,
  required final AppLogger _logger,
  required final RemoteRiftApiServiceRunner _runner,
}) extends Cubit<ServiceState> {
  this : super(Initial());

  void initialize() async {
    if (state is! Initial) {
      throw StateError(
        'Tried to initialize while not in initial state (was ${state.runtimeType})',
      );
    }

    emit(Starting());
    await _initializeDiagnostics();
    if (isClosed) return;
    await _startService();
  }

  void restart() async {
    final startupError = switch (state) {
      StartupError state => state,
      _ => throw StateError(
        'Tried to restart while not in error state (was ${state.runtimeType})',
      ),
    };

    emit(startupError.copyWith(restartTriggered: true));
    await _startService();
  }

  Future<void> dispose() async {
    await _runner.close();
  }

  Future<void> _initializeDiagnostics() async {
    try {
      final settings = await _settingsStore.load();
      _logger.setCaptureEnabled(settings.diagnosticLoggingEnabled);
    } on AppSettingsError {
      // Leave capture off when the saved preference cannot be read.
    }

    if (isClosed) return;
    _logger.appStarted();
  }

  Future<void> _startService() async {
    try {
      await _runner.run();
      emit(Started());
    } catch (error) {
      final newState = switch (error) {
        _ => StartupError(cause: .unknown),
      };
      emit(newState);
    }
  }
}
