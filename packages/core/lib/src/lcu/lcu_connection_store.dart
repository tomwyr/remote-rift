import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;

import 'lcu_connection.dart';

part 'lcu_connection_store.g.dart';

@JsonSerializable()
class LcuConnectionConfiguration({
  required final String? customPath,
}) {
  factory fromJson(Map<String, dynamic> json) => _$LcuConnectionConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$LcuConnectionConfigurationToJson(this);
}

class LcuConnectionConfigurationStore {
  Future<LcuConnectionConfiguration?> load() async {
    try {
      final file = _configurationFile();
      if (!await file.exists()) return null;

      return .fromJson(jsonDecode(await file.readAsString()));
    } catch (error) {
      if (error case FileSystemException() || FormatException() || TypeError()) {
        throw LcuConnectionError.configurationUnavailable;
      }
      rethrow;
    }
  }

  Future<void> save(LcuConnectionConfiguration configuration) async {
    try {
      final file = _configurationFile();
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode(configuration.toJson()));
    } on FileSystemException {
      throw LcuConnectionError.configurationUnavailable;
    }
  }

  Future<void> remove() async {
    try {
      final file = _configurationFile();
      if (await file.exists()) {
        await file.delete();
      }
    } on FileSystemException {
      throw LcuConnectionError.configurationUnavailable;
    }
  }

  File _configurationFile() {
    return File(path.join(_configurationDirectory().path, 'lcu-connection.json'));
  }

  Directory _configurationDirectory() {
    if (Platform.isWindows) {
      return _windowsDirectory();
    }
    if (Platform.isMacOS) {
      return _macosDirectory();
    }
    throw LcuConnectionError.unsupportedPlatform;
  }

  Directory _windowsDirectory() {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null || localAppData.isEmpty) {
      throw LcuConnectionError.configurationUnavailable;
    }
    return Directory(path.join(localAppData, 'Remote Rift'));
  }

  Directory _macosDirectory() {
    final home = Platform.environment['HOME'];
    if (home == null || home.isEmpty) {
      throw LcuConnectionError.configurationUnavailable;
    }
    return Directory(path.join(home, 'Library', 'Application Support', 'Remote Rift'));
  }
}
