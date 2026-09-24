import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:remote_rift_core/remote_rift_core.dart';

part 'app_settings_store.g.dart';

@JsonSerializable()
@CopyWith()
class AppSettings({
  required final bool mcpPreviouslyEnabled,
  required final bool mcpStartsOnLaunch,
  required final String? customLockfilePath,
}) {
  factory defaults() => AppSettings(
    mcpPreviouslyEnabled: false,
    mcpStartsOnLaunch: true,
    customLockfilePath: null,
  );

  factory fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

class AppSettingsStore implements LcuConnectionConfiguration {
  JsonFileStore<AppSettings>? _store;

  Future<AppSettings> load() async {
    return await _load() ?? .defaults();
  }

  Future<void> saveMcpStartsOnLaunch(bool mcpStartsOnLaunch) async {
    await _update(
      (settings) => settings.copyWith(mcpStartsOnLaunch: mcpStartsOnLaunch),
    );
  }

  Future<void> saveMcpPreviouslyEnabled(bool mcpPreviouslyEnabled) async {
    await _update(
      (settings) => settings.copyWith(mcpPreviouslyEnabled: mcpPreviouslyEnabled),
    );
  }

  @override
  Future<String?> loadCustomLockfilePath() async {
    final settings = await load();
    return settings.customLockfilePath;
  }

  @override
  Future<void> saveCustomLockfilePath(String customLockfilePath) async {
    await _update(
      (settings) => settings.copyWith(customLockfilePath: customLockfilePath),
    );
  }

  @override
  Future<void> clearCustomLockfilePath() async {
    await _update(
      (settings) => settings.copyWith(customLockfilePath: null),
    );
  }

  Future<AppSettings?> _load() async {
    try {
      return await _jsonStore().load();
    } catch (error) {
      if (error case FileSystemException() || FormatException() || TypeError()) {
        throw AppSettingsError.unavailable;
      }
      rethrow;
    }
  }

  Future<void> _update(
    AppSettings Function(AppSettings settings) update,
  ) async {
    try {
      await _jsonStore().update((settings) {
        final currentSettings = settings ?? AppSettings.defaults();
        return update(currentSettings);
      });
    } catch (error) {
      if (error case FileSystemException() || FormatException() || TypeError()) {
        throw AppSettingsError.unavailable;
      }
      rethrow;
    }
  }

  JsonFileStore<AppSettings> _jsonStore() {
    if (_store case var store?) {
      return store;
    }

    final settingsPath = path.join(_configurationDirectory().path, 'settings.json');
    final store = JsonFileStore<AppSettings>(
      path: settingsPath,
      fromJson: AppSettings.fromJson,
      toJson: (settings) => settings.toJson(),
    );
    _store = store;
    return store;
  }

  Directory _configurationDirectory() {
    if (Platform.isWindows) {
      final localAppData = Platform.environment['LOCALAPPDATA'];
      if (localAppData == null || localAppData.isEmpty) {
        throw AppSettingsError.unavailable;
      }
      return Directory(path.join(localAppData, 'Remote Rift'));
    }
    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home == null || home.isEmpty) throw AppSettingsError.unavailable;
      return Directory(path.join(home, 'Library', 'Application Support', 'Remote Rift'));
    }
    throw UnsupportedError('App settings are unavailable on this platform');
  }
}

enum AppSettingsError implements Exception { unavailable }
