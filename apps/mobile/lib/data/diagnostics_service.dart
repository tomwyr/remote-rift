import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:remote_rift_logging/remote_rift_logging.dart';

class DiagnosticsService({
  required final AppLogger _logger,
}) {
  LogStorageStatus get storageStatus => _logger.storageStatus;

  Stream<LogStorageStatus> get storageStatusChanges => _logger.storageStatusChanges;

  void setCaptureEnabled(bool enabled) {
    _logger.setCaptureEnabled(enabled);
  }

  Future<void> clearLogs() async {
    try {
      await _logger.clear();
    } catch (_) {
      throw DiagnosticsServiceError.clearFailed;
    }
  }

  /// Prepares a temporary snapshot, or returns null if there are no retained logs.
  ///
  /// The caller calls [discardShare] when sharing finishes or is abandoned.
  Future<File?> prepareShare() async {
    try {
      final directory = await getTemporaryDirectory();
      final snapshot = await _logger.prepareSnapshot(directory);
      return switch (snapshot) {
        SnapshotFile(:var file) => file,
        EmptySnapshot() => null,
      };
    } catch (_) {
      throw DiagnosticsServiceError.preparationFailed;
    }
  }

  Future<void> discardShare(File snapshot) async {
    try {
      if (await snapshot.exists()) {
        await snapshot.delete();
      }
      await snapshot.parent.delete();
    } catch (_) {
      throw DiagnosticsServiceError.discardFailed;
    }
  }
}

enum DiagnosticsServiceError implements Exception {
  clearFailed,
  preparationFailed,
  discardFailed,
}
