import 'dart:io';

import 'package:clock/clock.dart';

import 'log_config.dart';
import 'log_contents.dart';
import 'log_file.dart';

class LogStorage(Directory directory, final LogConfig _config) {
  final _file = LogFile(directory);
  LogContents? _contents;

  DateTime get _retentionCutoff => clock.now().toUtc().subtract(_config.maxAge);

  Future<void> prune() async {
    final contents = await _load();
    await _prune(contents, _retentionCutoff);
  }

  Future<void> append(DateTime timestamp, List<int> bytes) async {
    final cutoff = _retentionCutoff;
    final line = _lineForAppend(timestamp, bytes, cutoff);
    final contents = await _load();
    final retained = await _prune(contents, cutoff, incoming: line);
    if (line == null) return;

    await _file.append(line.bytes);
    retained.add(line);
  }

  Future<File?> snapshot(Directory temporaryDirectory) async {
    final contents = await _load();
    final retained = await _prune(contents, _retentionCutoff);
    if (retained.isEmpty) return null;

    return await _file.snapshot(temporaryDirectory);
  }

  Future<void> clear() async {
    await _file.clear();
    _contents = .empty();
  }

  void invalidate() {
    _contents = null;
  }

  Future<LogContents> _load() async {
    if (_contents case var contents?) return contents;

    final contents = await _file.read();
    _contents = contents;
    return contents;
  }

  LogLine? _lineForAppend(DateTime timestamp, List<int> bytes, DateTime cutoff) {
    if (bytes.length > _config.maxBytes || timestamp.isBefore(cutoff)) {
      return null;
    }
    return LogLine(timestamp, bytes);
  }

  Future<LogContents> _prune(LogContents contents, DateTime cutoff, {LogLine? incoming}) async {
    final maxBytes = _config.maxBytes - (incoming?.bytes.length ?? 0);
    final retained = contents.pruned(cutoff, maxBytes);
    if (retained == contents) return contents;

    await _file.replace(retained);
    _contents = retained;
    return retained;
  }
}
