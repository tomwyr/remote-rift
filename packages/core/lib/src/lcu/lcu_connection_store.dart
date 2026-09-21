abstract interface class LcuConnectionConfiguration {
  factory inMemory() => _InMemoryLcuConnectionConfiguration();

  Future<String?> loadCustomLockfilePath();

  Future<void> saveCustomLockfilePath(String customLockfilePath);

  Future<void> clearCustomLockfilePath();
}

class _InMemoryLcuConnectionConfiguration implements LcuConnectionConfiguration {
  String? _customLockfilePath;

  @override
  Future<String?> loadCustomLockfilePath() async => _customLockfilePath;

  @override
  Future<void> saveCustomLockfilePath(String customLockfilePath) async {
    _customLockfilePath = customLockfilePath;
  }

  @override
  Future<void> clearCustomLockfilePath() async {
    _customLockfilePath = null;
  }
}
