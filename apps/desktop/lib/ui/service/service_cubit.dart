import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_api/remote_rift_api.dart';

import '../../services/api_service_runner.dart';
import 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit({required this.runner}) : super(Initial());

  final RemoteRiftApiServiceRunner runner;

  void initialize() async {
    if (state is! Initial) {
      throw StateError(
        'Tried to initialize while not in initial state (was ${state.runtimeType})',
      );
    }

    emit(Starting());
    await _startService();
  }

  void completeStartup() async {
    final pendingState = switch (state) {
      PendingMultipleAddresses state => state,
      _ => throw StateError(
        'Tried to complete startup while not in multiple addresses state (was ${state.runtimeType})',
      ),
    };

    emit(pendingState.produce((draft) => draft.starting = true));
    await _startService(resolveAddress: true);
  }

  void restart() async {
    final startupError = switch (state) {
      StartupError state => state,
      _ => throw StateError(
        'Tried to restart while not in error state (was ${state.runtimeType})',
      ),
    };

    emit(startupError.produce((draft) => draft.restartTriggered = true));
    await _startService();
  }

  Future<void> _startService({bool resolveAddress = false}) async {
    try {
      await runner.run(resolveAddressOnMany: resolveAddress);
      emit(Started());
    } catch (error) {
      final newState = switch (error) {
        MultipleAddressesFound() => PendingMultipleAddresses(starting: false),
        AddressNotFound() => StartupError(cause: .addressNotFound),
        _ => StartupError(cause: .unknown),
      };
      emit(newState);
    }
  }

  Future<void> dispose() async {
    await runner.close();
  }
}
