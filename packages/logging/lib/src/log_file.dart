import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'log_contents.dart';

class LogFile(final Directory _directory) {
  final _file = File(path.join(_directory.path, 'log.ndjson'));
  final _rewrite = File(path.join(_directory.path, 'log-rewrite.tmp'));

  Future<LogContents> read() async {
    await _directory.create(recursive: true);
    await _discardRewrite();
    if (!await _file.exists()) {
      return .empty();
    }

    final (contents, needsRepair) = await _readContents();
    if (needsRepair) {
      await replace(contents);
    }
    return contents;
  }

  Future<void> append(List<int> bytes) async {
    await _file.writeAsBytes(bytes, mode: .append, flush: true);
  }

  Future<void> replace(LogContents contents) async {
    if (contents.isEmpty) {
      await _file.delete();
      return;
    }
    final bytes = contents.toBytes();
    await _rewrite.writeAsBytes(bytes, flush: true);
    await _rewrite.rename(_file.path);
  }

  Future<File> snapshot(Directory temporaryDirectory) async {
    await temporaryDirectory.create(recursive: true);
    final directory = await temporaryDirectory.createTemp('remote-rift-logs-');
    final filename = path.join(directory.path, 'remote-rift.ndjson');
    try {
      return await _file.copy(filename);
    } on FileSystemException {
      await directory.delete(recursive: true);
      rethrow;
    }
  }

  Future<void> clear() async {
    await _directory.create(recursive: true);
    await _discardRewrite();
    if (await _file.exists()) {
      await _file.delete();
    }
  }

  Future<void> _discardRewrite() async {
    if (await _rewrite.exists()) {
      await _rewrite.delete();
    }
  }

  Future<(LogContents, bool)> _readContents() async {
    final bytes = await _file.readAsBytes();
    final contents = LogContents.empty();
    for (final lineBytes in bytes.completeLines()) {
      if (LogLine.fromBytes(lineBytes) case var line?) {
        contents.add(line);
      }
    }
    final needsRepair = contents.byteLength != bytes.length || contents.isEmpty;
    return (contents, needsRepair);
  }
}
