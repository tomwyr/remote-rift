import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;

part 'mcp_configuration_store.g.dart';

@JsonSerializable()
class McpConfiguration({required final bool startsOnLaunch}) {
  factory fromJson(Map<String, dynamic> json) => _$McpConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$McpConfigurationToJson(this);
}

class McpConfigurationStore {
  Future<McpConfiguration> load() async {
    try {
      final file = _configurationFile();
      if (!await file.exists()) return McpConfiguration(startsOnLaunch: true);

      return .fromJson(jsonDecode(await file.readAsString()));
    } catch (error) {
      if (error case FileSystemException() || FormatException() || TypeError()) {
        throw McpConfigurationError.unavailable;
      }
      rethrow;
    }
  }

  Future<void> save(McpConfiguration configuration) async {
    try {
      final file = _configurationFile();
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode(configuration.toJson()));
    } on FileSystemException {
      throw McpConfigurationError.unavailable;
    }
  }

  File _configurationFile() {
    return File(path.join(_configurationDirectory().path, 'mcp.json'));
  }

  Directory _configurationDirectory() {
    if (Platform.isWindows) {
      final localAppData = Platform.environment['LOCALAPPDATA'];
      if (localAppData == null || localAppData.isEmpty) {
        throw McpConfigurationError.unavailable;
      }
      return Directory(path.join(localAppData, 'Remote Rift'));
    }
    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home == null || home.isEmpty) {
        throw McpConfigurationError.unavailable;
      }
      return Directory(path.join(home, 'Library', 'Application Support', 'Remote Rift'));
    }
    throw McpConfigurationError.unsupportedPlatform;
  }
}

enum McpConfigurationError { unavailable, unsupportedPlatform }
