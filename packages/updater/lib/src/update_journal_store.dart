import 'dart:convert';
import 'dart:io';

import 'models.dart';

class const UpdateJournalStore() {
  Future<void> write({
    required String path,
    required String expectedVersion,
    required String backupPath,
  }) async {
    final journal = UpdateJournal(version: expectedVersion, backupPath: backupPath);
    final content = jsonEncode(journal.toJson());
    await File(path).writeAsString(content, flush: true);
  }

  Future<void> delete(String path) async {
    final journal = File(path);
    if (await journal.exists()) {
      await journal.delete();
    }
  }

  Future<void> acknowledge({
    required String path,
    required String currentVersion,
  }) async {
    final journal = File(path);
    if (!await journal.exists()) {
      return;
    }

    late final UpdateJournal value;
    try {
      final content = await journal.readAsString();
      final json = jsonDecode(content);
      value = .fromJson(json);
    } catch (error) {
      if (error case FormatException() || TypeError()) {
        return;
      }
      rethrow;
    }

    if (value.version != currentVersion) {
      return;
    }
    final backup = Directory(value.backupPath);
    if (await backup.exists()) {
      await backup.delete(recursive: true);
    }
    await journal.delete();
  }
}
