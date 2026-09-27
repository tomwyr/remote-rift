import 'dart:async';

import 'package:remote_rift_core/src/timer_tick_resolver.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

import 'test_utils.dart';

void main() {
  testAsync('estimates elapsed time from its initial value before resolving a tick', (async) {
    final resolver = _createResolver(sample: () async => TimerTickElapsed(4.seconds));
    addTearDown(resolver.clear);

    resolver.start(initialElapsed: 4.seconds);
    async.elapse(25.milliseconds);

    expect(resolver.elapsedNow, 4.seconds + 25.milliseconds);
  });

  testAsync('anchors a tick at the midpoint', (async) {
    final resolver = _createResolver(sample: () async => TimerTickElapsed(5.seconds));
    addTearDown(resolver.clear);

    resolver.start(initialElapsed: 4.seconds);
    async.elapse(50.milliseconds);
    async.flushMicrotasks();

    expect(resolver.elapsedNow, 5.seconds + 25.milliseconds);
  });

  testAsync('slows sampling after resolving a tick', (async) {
    var samples = 0;
    final resolver = _createResolver(
      sample: () async {
        samples++;
        return TimerTickElapsed(5.seconds);
      },
    );
    addTearDown(resolver.clear);

    resolver.start(initialElapsed: 4.seconds);
    async.elapse(50.milliseconds);
    async.flushMicrotasks();

    expect(samples, 1);

    async.elapse(249.milliseconds);
    expect(samples, 1);

    async.elapse(1.milliseconds);
    async.flushMicrotasks();
    expect(samples, 2);
  });

  testAsync('continues advancing from a resolved anchor between samples', (async) {
    final resolver = _createResolver(sample: () async => TimerTickElapsed(5.seconds));
    addTearDown(resolver.clear);

    resolver.start(initialElapsed: 4.seconds);
    async.elapse(50.milliseconds);
    async.flushMicrotasks();

    async.elapse(100.milliseconds);
    expect(resolver.elapsedNow, 5.seconds + 125.milliseconds);
  });

  testAsync('does not start a second polling loop', (async) {
    var samples = 0;
    final resolver = _createResolver(
      sample: () async {
        samples++;
        return TimerTickElapsed(5.seconds);
      },
    );
    addTearDown(resolver.clear);

    resolver.start(initialElapsed: 4.seconds);
    resolver.start(initialElapsed: 7.seconds);
    async.elapse(50.milliseconds);
    async.flushMicrotasks();

    expect(samples, 1);
    expect(resolver.elapsedNow, 5.seconds + 25.milliseconds);
  });

  testAsync('ignores a completed sample from a cleared run', (async) {
    final firstSample = Completer<TimerTickSample>();
    var samples = 0;
    final resolver = _createResolver(
      sample: () async {
        samples++;
        return samples == 1 ? await firstSample.future : TimerTickElapsed(7.seconds);
      },
    );
    addTearDown(resolver.clear);

    resolver.start(initialElapsed: 4.seconds);
    async.elapse(50.milliseconds);
    async.flushMicrotasks();

    resolver.clear();
    resolver.start(initialElapsed: 7.seconds);
    firstSample.complete(TimerTickElapsed(5.seconds));
    async.flushMicrotasks();

    expect(resolver.isStarted, isTrue);
    expect(resolver.elapsedNow, 7.seconds);
  });

  testAsync('clears and stops polling when a sample is inactive', (async) {
    var samples = 0;
    final resolver = _createResolver(
      sample: () async {
        samples++;
        return TimerTickInactive();
      },
    );
    addTearDown(resolver.clear);

    resolver.start(initialElapsed: 4.seconds);
    async.elapse(50.milliseconds);
    async.flushMicrotasks();

    expect(resolver.isStarted, isFalse);
    expect(resolver.elapsedNow, 0.seconds);

    async.elapse(1.seconds);
    expect(samples, 1);
  });

  testAsync('retries after temporary unavailability without clearing its anchor', (async) {
    var samples = 0;
    final resolver = _createResolver(
      sample: () async {
        samples++;
        return samples == 1 ? TimerTickUnavailable() : TimerTickElapsed(5.seconds);
      },
    );
    addTearDown(resolver.clear);

    resolver.start(initialElapsed: 4.seconds);
    async.elapse(50.milliseconds);
    async.flushMicrotasks();

    expect(resolver.isStarted, isTrue);
    expect(resolver.elapsedNow, 4.seconds + 50.milliseconds);

    async.elapse(50.milliseconds);
    async.flushMicrotasks();
    expect(samples, 2);
    expect(resolver.elapsedNow, 5.seconds + 50.milliseconds);
  });

  testAsync('returns to narrow sampling after a multi-second jump', (async) {
    var samples = 0;
    final resolver = _createResolver(
      sample: () async {
        samples++;
        return switch (samples) {
          1 => TimerTickElapsed(5.seconds),
          2 => TimerTickElapsed(7.seconds),
          _ => TimerTickElapsed(8.seconds),
        };
      },
    );
    addTearDown(resolver.clear);

    resolver.start(initialElapsed: 4.seconds);
    async.elapse(50.milliseconds);
    async.flushMicrotasks();
    expect(samples, 1);

    async.elapse(250.milliseconds);
    async.flushMicrotasks();
    expect(samples, 2);

    async.elapse(50.milliseconds);
    async.flushMicrotasks();
    expect(samples, 3);
  });
}

TimerTickResolver _createResolver({required TimerTickSampler sample}) {
  return TimerTickResolver(
    tick: 1.seconds,
    initialSampleInterval: 50.milliseconds,
    resolvedSampleInterval: 250.milliseconds,
    sample: sample,
  );
}
