import 'dart:io';

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

  bool get canShare => actions.shareLogs != .pending;

  @override
  List<Object?> get props => [captureEnabled, storageStatus, actions];
}

@CopyWith()
class DiagnosticsActions({
  final DiagnosticsActionStatus loadPreference = .idle,
  final DiagnosticsActionStatus savePreference = .idle,
  final DiagnosticsActionStatus clearLogs = .idle,
  final LogShareStatus shareLogs = .idle,
}) extends Equatable {
  @override
  List<Object?> get props => [loadPreference, savePreference, clearLogs, shareLogs];
}

enum DiagnosticsActionStatus { idle, pending, failed }

enum LogShareStatus { idle, pending, preparationFailed, shareFailed }

sealed class DiagnosticsEvent;

class LogsCleared extends DiagnosticsEvent;

class LogSharePrepared(final File file) extends DiagnosticsEvent;

class NoLogsToShare extends DiagnosticsEvent;

class LogShareCancelled extends DiagnosticsEvent;

enum LogShareResult { finished, cancelled, failed }
