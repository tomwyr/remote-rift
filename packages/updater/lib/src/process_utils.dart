import 'dart:io';

import 'package:time/time.dart';

import 'platform.dart';

class const ProcessUtils() {
  Future<bool> waitForExit({
    required int processId,
    Duration timeout = const Duration(minutes: 1),
    Duration pollInterval = const Duration(milliseconds: 250),
  }) async {
    final started = DateTime.now();
    while (DateTime.now().difference(started) < timeout) {
      if (!await isRunning(processId)) {
        return true;
      }
      await pollInterval.delay;
    }
    return false;
  }

  Future<bool> isRunning(int processId) async {
    final result = switch (targetPlatform) {
      .macos => await Process.run('kill', ['-0', '$processId']),
      .windows => await Process.run('tasklist', [
        '/FI',
        'PID eq $processId',
        '/NH',
      ]),
    };
    return switch (targetPlatform) {
      .macos => result.exitCode == 0,
      .windows => result.stdout.toString().contains('$processId'),
    };
  }
}
