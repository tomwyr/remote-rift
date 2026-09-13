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

  Future<void> writeRecovery({
    required String path,
    required UpdateRecoveryCause cause,
  }) async {
    final recovery = UpdateRecoveryRecord(cause: cause);
    final content = jsonEncode(recovery.toJson());
    await File(path).writeAsString(content, flush: true);
  }

  Future<UpdateStartupResult> acknowledge({
    required String path,
    required String currentVersion,
  }) async {
    final journal = File(path);
    if (!await journal.exists()) {
      return NoUpdate();
    }

    late final UpdateJournal value;
    try {
      final content = await journal.readAsString();
      final json = jsonDecode(content);
      value = .fromJson(json);
    } catch (error) {
      if (error case FormatException() || TypeError()) {
        return InvalidJournal();
      }
      rethrow;
    }

    if (value.version != currentVersion) {
      return AwaitingAcknowledgement(
        expectedVersion: value.version,
        currentVersion: currentVersion,
      );
    }
    final backup = Directory(value.backupPath);
    if (await backup.exists()) {
      await backup.delete(recursive: true);
    }
    await journal.delete();
    return Acknowledged(version: value.version);
  }

  Future<UpdateStartupResult> consumeRecovery(String path) async {
    final recovery = File(path);
    if (!await recovery.exists()) {
      return NoUpdate();
    }

    late final UpdateRecoveryRecord value;
    try {
      final content = await recovery.readAsString();
      final json = jsonDecode(content);
      value = .fromJson(json);
    } catch (error) {
      if (error case FormatException() || TypeError()) {
        return InvalidRecovery();
      }
      rethrow;
    }

    await recovery.delete();
    return Recovered(cause: value.cause);
  }
}
