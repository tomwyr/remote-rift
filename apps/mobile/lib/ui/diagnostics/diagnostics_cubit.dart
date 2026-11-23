import 'dart:async';
import 'dart:io';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';

import '../../data/app_settings_store.dart';
import '../../data/diagnostics_service.dart';
import 'diagnostics_state.dart';

class DiagnosticsCubit({
  required final AppSettingsStore _settingsStore,
  required final DiagnosticsService _service,
}) extends Cubit<DiagnosticsState> {
  this : super(Initial());

  CancelableStream<LogStorageStatus>? _storageStatusChanges;

  final _events = StreamController<DiagnosticsEvent>.broadcast();
  Stream<DiagnosticsEvent> get events => _events.stream;

  void initialize() {
    _watchStorageStatus();
    _initializeCapture();
  }

  void updateCapture(bool enabled) async {
    final previous = state;
    if (previous is! Loaded || !previous.canChangeCapture) return;

    final actions = previous.actions.copyWith(savePreference: .pending);
    emit(previous.copyWith(actions: actions));
    try {
      await _settingsStore.saveDiagnosticLoggingEnabled(enabled);
      _service.setCaptureEnabled(enabled);
      if (isClosed) return;

      if (state case Loaded current) {
        final actions = current.actions.copyWith(loadPreference: .idle, savePreference: .idle);
        emit(current.copyWith(captureEnabled: enabled, actions: actions));
      }
    } on AppSettingsError {
      if (isClosed) return;
      if (state case Loaded current) {
        final actions = current.actions.copyWith(savePreference: .failed);
        emit(current.copyWith(actions: actions));
      }
    }
  }

  void clearLogs() async {
    final previous = state;
    if (previous is! Loaded || !previous.canClear) return;

    final actions = previous.actions.copyWith(clearLogs: .pending);
    emit(previous.copyWith(actions: actions));
    try {
      await _service.clearLogs();
      if (isClosed) return;

      if (state case Loaded current) {
        final actions = current.actions.copyWith(clearLogs: .idle);
        emit(current.copyWith(actions: actions));
        _events.add(LogsCleared());
      }
    } on DiagnosticsServiceError {
      if (isClosed) return;
      if (state case Loaded current) {
        final actions = current.actions.copyWith(clearLogs: .failed);
        emit(current.copyWith(actions: actions));
      }
    }
  }

  void shareLogs() async {
    final previous = state;
    if (previous is! Loaded || !previous.canShare) return;

    _updateShareStatus(.pending);
    final File? snapshot;
    try {
      snapshot = await _service.prepareShare();
    } on DiagnosticsServiceError {
      if (!isClosed) {
        _updateShareStatus(.preparationFailed);
      }
      return;
    }

    if (isClosed) {
      if (snapshot != null) {
        await _discardShare(snapshot);
      }
      return;
    }

    if (snapshot == null) {
      _updateShareStatus(.idle);
      _events.add(NoLogsToShare());
      return;
    }

    _events.add(LogSharePrepared(snapshot));
  }

  void completeShare(LogShareResult result, {required File snapshot}) async {
    await _discardShare(snapshot);
    if (isClosed) return;

    switch (result) {
      case .finished:
        _updateShareStatus(.idle);
      case .cancelled:
        _updateShareStatus(.idle);
        _events.add(LogShareCancelled());
      case .failed:
        _updateShareStatus(.shareFailed);
    }
  }

  void _updateShareStatus(LogShareStatus status) {
    if (state case Loaded current) {
      final actions = current.actions.copyWith(shareLogs: status);
      emit(current.copyWith(actions: actions));
    }
  }

  Future<void> _discardShare(File snapshot) async {
    try {
      await _service.discardShare(snapshot);
    } on DiagnosticsServiceError {
      // A cleanup failure does not change the share outcome.
    }
  }

  void _watchStorageStatus() async {
    final changes = _service.storageStatusChanges.cancelable();
    _storageStatusChanges = changes;

    await for (var status in changes) {
      if (state case Loaded current) {
        emit(current.copyWith(storageStatus: status));
      }
    }
  }

  void _initializeCapture() async {
    var captureEnabled = false;
    var loadPreference = DiagnosticsActionStatus.idle;
    try {
      final settings = await _settingsStore.load();
      captureEnabled = settings.diagnosticLoggingEnabled;
    } on AppSettingsError {
      loadPreference = .failed;
    }

    if (isClosed) return;

    if (loadPreference == .idle) {
      _service.setCaptureEnabled(captureEnabled);
    }
    final actions = DiagnosticsActions(loadPreference: loadPreference);
    emit(
      Loaded(
        captureEnabled: captureEnabled,
        storageStatus: _service.storageStatus,
        actions: actions,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _storageStatusChanges?.cancel();
    await [super.close(), _events.close()].wait;
  }
}
