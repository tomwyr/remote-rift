import 'package:clock/clock.dart';
import 'package:time/time.dart';

typedef TimerTickSampler = Future<TimerTickSample> Function();

class TimerTickResolver({
  required final Duration tick,
  required final Duration initialSampleInterval,
  required final Duration resolvedSampleInterval,
  required final TimerTickSampler _sample,
}) {
  this
    : assert(tick > .zero, 'Timer tick must be positive.'),
      assert(initialSampleInterval > .zero, 'Initial sample interval must be positive.'),
      assert(resolvedSampleInterval > .zero, 'Resolved sample interval must be positive.');

  final _stopwatch = clock.stopwatch();

  Duration _initialElapsed = .zero;
  Duration _initialObservedAt = .zero;

  Duration _lastElapsed = .zero;
  Duration _lastObservedAt = .zero;

  Duration? _resolvedElapsed;
  Duration? _resolvedObservedAt;

  var _hasStarted = false;
  var _needsResolution = true;

  Object? _run;

  bool get isStarted => _hasStarted;

  Duration get elapsedNow {
    final elapsed = _resolvedElapsed ?? _initialElapsed;
    final observedAt = _resolvedObservedAt ?? _initialObservedAt;
    return elapsed + _stopwatch.elapsed - observedAt;
  }

  void start({required Duration initialElapsed}) {
    if (_hasStarted) return;
    _hasStarted = true;
    _stopwatch.start();
    _initializeElapsed(initialElapsed);
    final run = _run = Object();
    _resolve(run);
  }

  void clear() {
    _stopwatch
      ..stop()
      ..reset();
    _clearElapsed();
    _hasStarted = false;
    _run = null;
  }

  Future<void> _resolve(Object run) async {
    while (_run == run) {
      await _waitForNextSample();
      if (_run != run) return;

      final sample = await _sample();
      if (_run != run) return;
      if (sample case TimerTickElapsed(:final elapsed)) {
        _record(elapsed);
      } else if (sample case TimerTickInactive()) {
        clear();
        return;
      }
    }
  }

  Future<void> _waitForNextSample() async {
    final sampleInterval = _needsResolution ? initialSampleInterval : resolvedSampleInterval;
    await sampleInterval.delay;
  }

  void _record(Duration sampleElapsed) {
    final sampleObservedAt = _stopwatch.elapsed;
    _resolveElapsed(sampleElapsed, sampleObservedAt);
    _lastElapsed = sampleElapsed;
    _lastObservedAt = sampleObservedAt;
  }

  void _resolveElapsed(Duration sampleElapsed, Duration sampleObservedAt) {
    // A multi-second gap cannot identify a precise tick boundary.
    if (sampleElapsed > _lastElapsed + tick) {
      _needsResolution = true;
      return;
    }
    // An unchanged sample does not provide a new tick boundary.
    if (sampleElapsed != _lastElapsed + tick) {
      return;
    }

    // The whole-second transition occurred between the adjacent observations.
    final transitionAt = _midpoint(_lastObservedAt, sampleObservedAt);
    // Advance the observed value from the estimated transition to this observation.
    _resolvedElapsed = sampleElapsed + sampleObservedAt - transitionAt;
    _resolvedObservedAt = sampleObservedAt;
    _needsResolution = false;
  }

  Duration _midpoint(Duration first, Duration second) {
    return first + (second - first) ~/ 2;
  }

  void _initializeElapsed(Duration elapsed) {
    final observedAt = _stopwatch.elapsed;
    _initialElapsed = elapsed;
    _initialObservedAt = observedAt;
    _lastElapsed = elapsed;
    _lastObservedAt = observedAt;
  }

  void _clearElapsed() {
    _initialElapsed = .zero;
    _initialObservedAt = .zero;
    _lastElapsed = .zero;
    _lastObservedAt = .zero;
    _resolvedElapsed = null;
    _resolvedObservedAt = null;
    _needsResolution = true;
  }
}

sealed class TimerTickSample();

class TimerTickElapsed(final Duration elapsed) extends TimerTickSample;

class TimerTickInactive() extends TimerTickSample;

class TimerTickUnavailable() extends TimerTickSample;
