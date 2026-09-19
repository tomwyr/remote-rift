import 'dart:io';

import 'lcu_connection_store.dart';

class LcuConnection({
  required final LcuLockfileParser _parser,
  required final LcuLockfileLoader _loader,
  required final LcuLockfilePath _path,
}) {
  factory createShared() {
    return LcuConnection(
      parser: LcuLockfileParser(),
      loader: LcuLockfileLoader(),
      path: LcuLockfilePath(store: LcuConnectionConfigurationStore()),
    );
  }

  static final shared = LcuConnection.createShared();

  LcuLockfileData? _lockfileData;

  LcuLockfileData getLockfileData() {
    if (_lockfileData case var data?) {
      return data;
    }
    return refreshLockfileData();
  }

  LcuLockfileData refreshLockfileData() {
    try {
      final lockfile = _loader.loadLockfile(_path.getActivePath());
      final data = _parser.parseLockfile(lockfile);
      _lockfileData = data;
      return data;
    } catch (_) {
      _lockfileData = null;
      rethrow;
    }
  }

  void validateLockfilePath(String path) {
    final lockfile = _loader.loadLockfile(path);
    _parser.parseLockfile(lockfile);
  }

  String? get lockfileCustomPath => _path.getCustomPath();

  void saveLockfileCustomPath(String path) {
    _path.saveCustomPath(path);
    _lockfileData = null;
  }

  void resetLockfileCustomPath() {
    _path.reset();
    _lockfileData = null;
  }
}

class LcuLockfilePath({
  required final LcuConnectionConfigurationStore _store,
}) {
  String? _customPath;
  var _loaded = false;

  String getActivePath() {
    return getCustomPath() ?? _defaultPath();
  }

  String? getCustomPath() {
    _load();
    return _customPath;
  }

  void saveCustomPath(String path) {
    _load();
    _store.save(LcuConnectionConfiguration(customPath: path));
    _customPath = path;
  }

  void reset() {
    _load();
    _store.remove();
    _customPath = null;
  }

  void _load() {
    if (_loaded) return;
    _customPath = _store.load()?.customPath;
    _loaded = true;
  }

  String _defaultPath() {
    if (Platform.isWindows) {
      return 'C:\\Riot Games\\League of Legends\\lockfile';
    }
    if (Platform.isMacOS) {
      return '/Applications/League of Legends.app/Contents/LoL/lockfile';
    }
    throw LcuConnectionError.unsupportedPlatform;
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
  String loadLockfile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw LcuConnectionError.lockfileMissing;
    }
    return file.readAsStringSync();
  }
}

class LcuLockfileData({
  required final int port,
  required final String password,
});

enum LcuConnectionError implements Exception {
  unsupportedPlatform,
  lockfileMissing,
  lockfileInvalid,
  configurationUnavailable,
}
