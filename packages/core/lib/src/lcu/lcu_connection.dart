import 'dart:io';

class LcuConnection({
  required final LcuLockfileParser _parser,
  required final LcuLockfileLoader _loader,
}) {
  LcuLockfileData? _lockfileData;

  LcuLockfileData getLockfileData() {
    if (_lockfileData case var data?) {
      return data;
    }
    return refreshLockfileData();
  }

  LcuLockfileData refreshLockfileData() {
    try {
      final data = _parser.parseLockfile(_loader.loadLockfile());
      _lockfileData = data;
      return data;
    } catch (_) {
      _lockfileData = null;
      rethrow;
    }
  }
}

class LcuLockfileParser {
  LcuLockfileData parseLockfile(String data) {
    int? port;
    String? password;

    final regex = RegExp(r'^(.+):(\d+):(\d+):(.*):(.*)$');
    if (regex.firstMatch(data) case var result?) {
      if (result.group(3) case var portValue?) {
        port = int.tryParse(portValue);
      }
      password = result.group(4);
    }

    if (port == null || password == null) {
      throw LcuConnectionError.lockfileInvalid;
    }

    return LcuLockfileData(port: port, password: password);
  }
}

class LcuLockfileLoader {
  String loadLockfile() {
    final path = _getPlatformPath();
    final file = File(path);
    if (!file.existsSync()) {
      throw LcuConnectionError.lockfileMissing;
    }
    return file.readAsStringSync();
  }

  String _getPlatformPath() {
    if (Platform.isWindows) {
      return 'C:\\Riot Games\\League of Legends\\lockfile';
    } else if (Platform.isMacOS) {
      return '/Applications/League of Legends.app/Contents/LoL/lockfile';
    } else {
      throw LcuConnectionError.unsupportedPlatform;
    }
  }
}

class LcuLockfileData({
  required final int port,
  required final String password,
}) {}

enum LcuConnectionError implements Exception {
  unsupportedPlatform,
  lockfileMissing,
  lockfileInvalid,
}
