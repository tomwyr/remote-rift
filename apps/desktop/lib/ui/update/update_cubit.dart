import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_updater/remote_rift_updater.dart';

import 'update_state.dart';

class UpdateCubit({
  required final ApplicationUpdater _updater,
}) extends Cubit<UpdateState> {
  this : super(Initial());

  void initialize() async {
    _assertInitializeState();
    try {
      final update = await _updater.checkUpdateAvailable();
      if (update != null) {
        emit(UpdateAvailable(update: update));
      } else {
        emit(UpToDate());
      }
    } on ApplicationUpdaterError {
      emit(UpdateCheckFailed());
    }
  }

  void installUpdate() async {
    final update = _assertInstallUpdateState();
    try {
      emit(UpdateInProgress());
      await _updater.installUpdate(update: update);
    } on ApplicationUpdaterError {
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

  UpdateRelease _assertInstallUpdateState() {
    return switch (state) {
      UpdateAvailable(:var update) || UpdateError(:var update) => update,
      _ => throw StateError(
        'Tried to install update while not in updatable state (was ${state.runtimeType})',
      ),
    };
  }
}
