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

  Future<LcuLockfileData> getLockfileData() async {
    if (_lockfileData case var data?) {
      return data;
    }
    return await refreshLockfileData();
  }

  Future<LcuLockfileData> refreshLockfileData() async {
    try {
      final activePath = await _path.getActivePath();
      final lockfile = _loader.loadLockfile(activePath);
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

  Future<String?> getLockfileCustomPath() => _path.getCustomPath();

  Future<void> saveLockfileCustomPath(String path) async {
    await _path.saveCustomPath(path);
    _lockfileData = null;
  }

  Future<void> resetLockfileCustomPath() async {
    await _path.reset();
    _lockfileData = null;
  }
}

class LcuLockfilePath({
  required final LcuConnectionConfigurationStore _store,
}) {
  String? _customPath;
  var _loaded = false;
  Future<void>? _loading;

  Future<String> getActivePath() async {
    return await getCustomPath() ?? _defaultPath();
  }

  Future<String?> getCustomPath() async {
    await _load();
    return _customPath;
  }

  Future<void> saveCustomPath(String path) async {
    await _load();
    await _store.save(LcuConnectionConfiguration(customPath: path));
    _customPath = path;
  }

  Future<void> reset() async {
    await _load();
    await _store.remove();
    _customPath = null;
  }

  Future<void> _load() async {
    if (_loaded) return;
    if (_loading case var loading?) return await loading;

    final loading = _loadConfiguration();
    _loading = loading;

    try {
      await loading;
    } finally {
      _loading = null;
    }
  }

  Future<void> _loadConfiguration() async {
    final configuration = await _store.load();
    _customPath = configuration?.customPath;
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
