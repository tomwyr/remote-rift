import 'dart:async';
import 'dart:io';

class LogStorageQueue(final void Function() _invalidate) {
  final _statusChanges = StreamController<LogStorageStatus>.broadcast();
  var _status = LogStorageStatus.ready;
  Future<void>? _inFlight;

  LogStorageStatus get status => _status;

  Stream<LogStorageStatus> get statusChanges => _statusChanges.stream;

  Future<T> run<T>(Future<T> Function() operation) async {
    final previous = _inFlight;
    final completion = Completer<void>();
    final inFlight = completion.future;
    _inFlight = inFlight;

    try {
      return await _runAfter(previous, operation);
    } finally {
      completion.complete();
      if (_inFlight == inFlight) {
        _inFlight = null;
      }
    }
  }

  Future<T> _runAfter<T>(Future<void>? previous, Future<T> Function() operation) async {
    if (previous != null) {
      await previous;
    }
    try {
      final value = await operation();
      _updateStatus(.ready);
      return value;
    } on FileSystemException {
      _invalidate();
      _updateStatus(.unavailable);
      throw LogStorageError.unavailable;
    }
  }

  void _updateStatus(LogStorageStatus status) {
    if (_status == status) return;
    _status = status;
    _statusChanges.add(status);
  }
}

enum LogStorageStatus { ready, unavailable }

enum LogStorageError implements Exception { unavailable }
