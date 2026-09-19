import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

import 'settings_state.dart';

class SettingsCubit({
  required final LcuConnection _connection,
}) extends Cubit<SettingsState> {
  this : super(Initial());

  void initialize() {
    try {
      emit(Loaded(customPath: _connection.lockfileCustomPath));
    } on LcuConnectionError catch (error) {
      if (error case .configurationUnavailable) {
        emit(Loaded(customPath: null, failure: .pathPersistence));
        return;
      }
      rethrow;
    }
  }

  void selectCustomPath(String path) {
    final previous = _requireLoaded();
    emit(Loaded(customPath: previous.customPath, saving: true));

    try {
      _connection.validateLockfilePath(path);
      _connection.saveLockfileCustomPath(path);
      emit(Loaded(customPath: path));
    } on LcuConnectionError catch (error) {
      if (error case .configurationUnavailable) {
        emit(Loaded(customPath: previous.customPath, failure: .pathPersistence));
        return;
      }
      if (error case .lockfileMissing || .lockfileInvalid) {
        emit(Loaded(customPath: previous.customPath, failure: .invalidLockfile));
        return;
      }
      rethrow;
    }
  }

  void reset() {
    final previous = _requireLoaded();
    emit(Loaded(customPath: previous.customPath, saving: true));

    try {
      _connection.resetLockfileCustomPath();
      emit(Loaded(customPath: null));
    } on LcuConnectionError catch (error) {
      if (error case .configurationUnavailable) {
        emit(Loaded(customPath: previous.customPath, failure: .pathPersistence));
        return;
      }
      rethrow;
    }
  }

  Loaded _requireLoaded() {
    return switch (state) {
      Loaded state => state,
      Initial() => throw StateError('Tried to update settings before initialization'),
    };
  }
}
