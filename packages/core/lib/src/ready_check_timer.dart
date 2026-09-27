import 'package:remote_rift_utils/remote_rift_utils.dart';
import 'package:time/time.dart';

import 'lcu/lcu_api_client.dart';
import 'lcu/lcu_connection.dart';
import 'lcu/lcu_models.dart';
import 'timer_tick_resolver.dart';

class ReadyCheckTimer({
  required final LcuApiClient _lcuApi,
}) {
  final maxTime = 10.seconds;

  late final _resolver = TimerTickResolver(
    tick: 1.seconds,
    initialSampleInterval: 50.milliseconds,
    resolvedSampleInterval: 250.milliseconds,
    sample: _sampleElapsed,
  );

  Duration timeLeft(ReadyCheck readyCheck) {
    final elapsed = _resolver.isStarted ? _resolver.elapsedNow : readyCheck.timer.seconds;
    return (maxTime - elapsed).nonNegative;
  }

  void start(ReadyCheck readyCheck) {
    _resolver.start(initialElapsed: readyCheck.timer.seconds);
  }

  void clear() {
    _resolver.clear();
  }

  Future<TimerTickSample> _sampleElapsed() async {
    try {
      final readyCheck = await _lcuApi.getReadyCheck();
      if (readyCheck.state != .inProgress) {
        return TimerTickInactive();
      }
      return TimerTickElapsed(readyCheck.timer.seconds);
    } on LcuConnectionError catch (_) {
      return TimerTickUnavailable();
    } on LcuApiClientError catch (_) {
      return TimerTickUnavailable();
    }
  }
}
