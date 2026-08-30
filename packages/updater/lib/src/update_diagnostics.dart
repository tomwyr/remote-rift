import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

class const UpdateDiagnostics() {
  Future<void> record({required String event, String? detail}) async {
    try {
      final log = File(join(Directory.systemTemp.path, 'updater.log'));
      final record = jsonEncode({
        'time': DateTime.now().toUtc().toIso8601String(),
        'event': event,
        'detail': ?detail,
      });
      await log.writeAsString('$record\n', mode: .append, flush: true);
    } on FileSystemException {
      // Diagnostics must never influence update behavior.
    }
  }
}
