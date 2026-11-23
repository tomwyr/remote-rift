import 'dart:io';

import 'package:clock/clock.dart';

import 'log_config.dart';
import 'log_record.dart';
import 'log_storage.dart';
import 'log_storage_queue.dart';

/// Records application events and manages retained logs.
class AppLogger._(
  final LogStorage _storage,
  final String _app,
  final String _appVersion,
  final String _sessionId,
) {
  final _queue = LogStorageQueue(_storage.invalidate);
  var _captureEnabled = false;

  /// The result of the most recent storage operation.
  LogStorageStatus get storageStatus => _queue.status;

  /// Emits subsequent changes to [storageStatus].
  Stream<LogStorageStatus> get storageStatusChanges => _queue.statusChanges;

  /// Opens a logger with capture disabled and prunes existing records to the retention limits.
  ///
  /// Open one logger per [storageDirectory] to serialize storage operations.
  /// Omit [config] to use the default limits. If pruning fails, the returned logger reports
  /// [LogStorageStatus.unavailable] through [storageStatus].
  static Future<AppLogger> open({
    required Directory storageDirectory,
    required String app,
    required String appVersion,
    required String sessionId,
    LogConfig? config,
  }) async {
    final retention = config ?? LogConfig();
    final storage = LogStorage(storageDirectory, retention);
    final logger = AppLogger._(storage, app, appVersion, sessionId);
    try {
      await logger._queue.run(storage.prune);
    } on LogStorageError {
      // Return the logger so callers can observe the failure and retry storage operations.
    }
    return logger;
  }

  void setCaptureEnabled(bool enabled) {
    _captureEnabled = enabled;
  }

  /// Records an event if capture is enabled.
  ///
  /// Supply a stable [event] name and allowlisted JSON [details]. If writing fails,
  /// [storageStatus] reports the failure.
  Future<void> record(
    String event,
    LogSeverity severity, {
    Map<String, Object?>? details,
  }) async {
    if (!_captureEnabled) return;

    final timestamp = clock.now().toUtc();
    final record = LogRecord(
      schemaVersion: 1,
      timestamp: timestamp,
      app: _app,
      appVersion: _appVersion,
      sessionId: _sessionId,
      severity: severity,
      event: event,
      details: details,
    );
    final bytes = record.encodeLine();

    try {
      await _queue.run(() => _storage.append(timestamp, bytes));
    } on LogStorageError {
      // Report the failure through storageStatus so the operation being logged can continue.
    }
  }

  /// Prepares the retained records for sharing or export.
  ///
  /// Returns [EmptySnapshot] if there are no records. Otherwise, creates a subdirectory of
  /// [temporaryDirectory] and returns a [SnapshotFile] in it. The caller deletes the subdirectory
  /// after sharing or export finishes.
  Future<LogSnapshot> prepareSnapshot(Directory temporaryDirectory) async {
    final file = await _queue.run(() => _storage.snapshot(temporaryDirectory));
    return file == null ? EmptySnapshot() : SnapshotFile(file);
  }

  Future<void> clear() async {
    await _queue.run(_storage.clear);
  }
}

sealed class LogSnapshot;

class EmptySnapshot extends LogSnapshot;

/// A file containing the log records retained at the time of the snapshot.
class SnapshotFile(final File file) extends LogSnapshot;
