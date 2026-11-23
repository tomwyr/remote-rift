import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';

part 'diagnostics_state.g.dart';

sealed class DiagnosticsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends DiagnosticsState;

@CopyWith()
class Loaded({
  required final bool captureEnabled,
  required final LogStorageStatus storageStatus,
  required final DiagnosticsActions actions,
}) extends DiagnosticsState {
  bool get canChangeCapture => actions.savePreference != .pending;

  bool get canClear => actions.clearLogs != .pending;

  bool get canExport => actions.exportLogs != .pending;

  @override
  List<Object?> get props => [captureEnabled, storageStatus, actions];
}

@CopyWith()
class DiagnosticsActions({
  final DiagnosticsActionStatus loadPreference = .idle,
  final DiagnosticsActionStatus savePreference = .idle,
  final DiagnosticsActionStatus clearLogs = .idle,
  final LogExportStatus exportLogs = .idle,
}) extends Equatable {
  @override
  List<Object?> get props => [loadPreference, savePreference, clearLogs, exportLogs];
}

enum DiagnosticsActionStatus { idle, pending, failed }

enum LogExportStatus { idle, pending, preparationFailed, saveFailed }

sealed class DiagnosticsEvent;

class LogsCleared extends DiagnosticsEvent;

class LogExportPrepared(final String filename) extends DiagnosticsEvent;

class LogsExported extends DiagnosticsEvent;

class NoLogsToExport extends DiagnosticsEvent;

class LogExportCancelled extends DiagnosticsEvent;

sealed class ExportDestinationResult;

class ExportPath(final String path) extends ExportDestinationResult;

class ExportCancelled extends ExportDestinationResult;

class ExportDestinationFailed extends ExportDestinationResult;
