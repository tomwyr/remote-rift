import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:remote_rift_core/remote_rift_core.dart';

part 'app_settings_store.g.dart';

@JsonSerializable()
class AppSettings({required final bool diagnosticLoggingEnabled}) {
  factory defaults() => AppSettings(diagnosticLoggingEnabled: false);

  factory fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

class AppSettingsStore(Directory directory) {
  final _store = JsonFileStore<AppSettings>(
    path: path.join(directory.path, 'settings.json'),
    fromJson: AppSettings.fromJson,
    toJson: (settings) => settings.toJson(),
  );

  static Future<AppSettingsStore> open() async {
    final directory = await getApplicationSupportDirectory();
    return AppSettingsStore(directory);
  }

  Future<AppSettings> load() async {
    try {
      return await _store.load() ?? .defaults();
    } catch (error) {
      if (error case FileSystemException() || FormatException() || TypeError()) {
        throw AppSettingsError.unavailable;
      }
      rethrow;
    }
  }

  Future<void> saveDiagnosticLoggingEnabled(bool enabled) async {
    try {
      await _store.save(AppSettings(diagnosticLoggingEnabled: enabled));
    } on FileSystemException {
      throw AppSettingsError.unavailable;
    }
  }
}

enum AppSettingsError implements Exception { unavailable }
