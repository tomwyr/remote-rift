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
  LcuConnectionConfiguration? load() {
    try {
      final file = _configurationFile();
      if (!file.existsSync()) return null;

      return .fromJson(jsonDecode(file.readAsStringSync()));
    } catch (error) {
      if (error case FileSystemException() || FormatException() || TypeError()) {
        throw LcuConnectionError.configurationUnavailable;
      }
      rethrow;
    }
  }

  void save(LcuConnectionConfiguration configuration) {
    try {
      final file = _configurationFile();
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(jsonEncode(configuration.toJson()));
    } on FileSystemException {
      throw LcuConnectionError.configurationUnavailable;
    }
  }

  void remove() {
    try {
      final file = _configurationFile();
      if (file.existsSync()) {
        file.deleteSync();
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
