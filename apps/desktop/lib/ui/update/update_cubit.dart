import 'package:application_updater/application_updater.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit({required this.updater}) : super(Initial());

  final ApplicationUpdater updater;

  void initialize() async {
    _assertInitializeState();
    final update = await updater.checkUpdateAvailable();
    if (update != null) {
      emit(UpdateAvailable(update: update));
    } else {
      emit(UpToDate());
    }
  }

  void installUpdate() async {
    final update = _assertInstallUpdateState();
    try {
      emit(UpdateInProgress());
      await updater.installUpdate(update: update);
    } catch (_) {
      emit(UpdateError(update: update));
    }
  }

  void recoverOnDismiss() {
    if (state case UpdateError(:var update)) {
      emit(UpdateAvailable(update: update));
    }
  }
}

extension UpdateCubitAssertions on UpdateCubit {
  void _assertInitializeState() {
    if (state is! Initial) {
      throw StateError(
        'Tried to initialize while not in initial state (was ${state.runtimeType})',
      );
    }
  }

  AvailableUpdate _assertInstallUpdateState() {
    return switch (state) {
      UpdateAvailable(:var update) || UpdateError(:var update) => update,
      _ => throw StateError(
        'Tried to install update while not in updatable state (was ${state.runtimeType})',
      ),
    };
  }
}
