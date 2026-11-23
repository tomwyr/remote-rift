import 'dart:async';
import 'dart:io';

import 'package:cancelable_stream/cancelable_stream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../../services/app_settings_store.dart';
import '../../services/diagnostics_service.dart';
import 'diagnostics_state.dart';

class DiagnosticsCubit({
  required final AppSettingsStore _settingsStore,
  required final DiagnosticsService _service,
}) extends Cubit<DiagnosticsState> {
  this : super(Initial());

  CancelableStream<LogStorageStatus>? _storageStatusChanges;
  File? _exportSnapshot;

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

  void exportLogs() async {
    final previous = state;
    if (previous is! Loaded || !previous.canExport) {
      return;
    }

    _updateExportStatus(.pending);
    final File? snapshot;
    try {
      snapshot = await _service.prepareExport();
    } on DiagnosticsServiceError {
      if (!isClosed) {
        _updateExportStatus(.preparationFailed);
      }
      return;
    }

    if (isClosed) {
      if (snapshot != null) {
        await _discardExport(snapshot);
      }
      return;
    }

    if (snapshot == null) {
      _updateExportStatus(.idle);
      _events.add(NoLogsToExport());
      return;
    }

    _exportSnapshot = snapshot;
    _events.add(LogExportPrepared(snapshot.basename));
  }

  void completeExport(ExportDestinationResult destination) async {
    final snapshot = _exportSnapshot;
    if (snapshot == null) return;

    _exportSnapshot = null;
    switch (destination) {
      case ExportPath(:var path):
        final exported = await _saveExport(snapshot, path);
        if (isClosed) return;
        _updateExportStatus(exported ? .idle : .saveFailed);
        if (exported) {
          _events.add(LogsExported());
        }

      case ExportCancelled():
        await _discardExport(snapshot);
        if (isClosed) return;
        _updateExportStatus(.idle);
        _events.add(LogExportCancelled());

      case ExportDestinationFailed():
        await _discardExport(snapshot);
        if (isClosed) return;
        _updateExportStatus(.saveFailed);
    }
  }

  Future<bool> _saveExport(File snapshot, String destination) async {
    try {
      await _service.saveExport(snapshot, destination);
      return true;
    } on DiagnosticsServiceError {
      return false;
    } finally {
      await _discardExport(snapshot);
    }
  }

  void _updateExportStatus(LogExportStatus status) {
    if (state case Loaded current) {
      final actions = current.actions.copyWith(exportLogs: status);
      emit(current.copyWith(actions: actions));
    }
  }

  Future<void> _discardExport(File snapshot) async {
    try {
      await _service.discardExport(snapshot);
    } on DiagnosticsServiceError {
      // A cleanup failure does not change the export outcome.
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
    final snapshot = _exportSnapshot;
    _exportSnapshot = null;
    await [
      super.close(),
      _events.close(),
      if (snapshot != null) _discardExport(snapshot),
    ].wait;
  }
}
