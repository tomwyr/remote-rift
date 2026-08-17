import 'dart:async';

import 'types.dart';

enum RetrySchedulerStatus { idle, pending, running }

class RetryScheduler({
  required final RetryBackoff _backoff,
  required final AsyncCallback _onRetry,
}) {
  RetrySchedulerStatus get status => _status;

  var _status = RetrySchedulerStatus.idle;
  Timer? _timer;

  void start() {
    if (_status == .idle) {
      _scheduleRetry();
    }
  }

  void trigger() {
    if (_status == .pending) {
      _timer?.cancel();
      _runRetry(countAttempt: false);
    }
  }

  void reset() {
    _timer?.cancel();
    _status = .idle;
    _backoff.reset();
  }

  void _scheduleRetry() {
    _timer = Timer(_backoff.currentDelay(), _runRetry);
    _status = .pending;
  }

  Future<void> _runRetry({bool countAttempt = true}) async {
    _status = .running;
    try {
      await _onRetry();
    } finally {
      if (_status != .idle) {
        if (countAttempt) _backoff.tick();
        _scheduleRetry();
      }
    }
  }
}

class RetryBackoff({
  required final Duration startDelay,
  final Duration? maxDelay,
  required final Duration delayStep,
}) {
  this
    : assert(
        maxDelay == null || maxDelay >= startDelay,
        'Max delay must not be lower than start delay.',
      );

  static final standard = RetryBackoff(
    startDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 5),
    delayStep: Duration(seconds: 1),
  );

  var _retries = 0;

  Duration tick() {
    _retries++;
    return currentDelay();
  }

  void reset() {
    _retries = 0;
  }

  Duration currentDelay() {
    var delay = startDelay + delayStep * _retries;
    if (maxDelay case var maxDelay?) {
      delay = delay <= maxDelay ? delay : maxDelay;
    }
    return delay;
  }
}
