import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/api_service_runner.dart';
import 'service_state.dart';

class ServiceCubit({
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

  Future<void> dispose() async {
    await _runner.close();
  }
}
