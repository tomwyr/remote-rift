import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart';

import 'platform.dart';

class FileUtils {
  const FileUtils();

  String getApplicationDirectory() {
    final exeDir = File(Platform.resolvedExecutable).parent;

    switch (targetPlatform) {
      case .windows:
        return exeDir.path;

      case .macos:
        return exeDir.parent.parent.path;
    }
  }

  String getAssetsDirectory() {
    final exeDir = File(Platform.resolvedExecutable).parent;

    switch (targetPlatform) {
      case .windows:
        return join(exeDir.path, 'data', 'flutter_assets', 'assets');

      case .macos:
        final contentsPath = normalize(join(exeDir.path, '..'));
        return join(
          contentsPath,
          'Frameworks',
          'App.framework',
          'Resources',
          'flutter_assets',
          'assets',
        );
    }
  }

  Future<String> unzipFile(String zipPath) async {
    if (!zipPath.endsWith('.zip')) {
      throw ArgumentError('Expected a file with a .zip extension');
    }
    if (!await File(zipPath).exists()) {
      throw Exception('Zip file does not exist: $zipPath');
    }

    final outputDir = Directory(withoutExtension(zipPath));
    if (await outputDir.exists()) {
      await outputDir.delete(recursive: true);
    }

    await extractFileToDisk(zipPath, outputDir.path);
    return outputDir.path;
  }

  Future<void> replaceWithBackup({
    required String sourcePath,
    required String targetPath,
    required String backupPath,
    bool recursive = false,
  }) async {
    final source = Directory(sourcePath);
    if (!await source.exists()) {
      throw ArgumentError('Source directory does not exist: $source');
    }

    print(sourcePath);
    print(targetPath);
    print(backupPath);

    final backup = Directory(backupPath);
    if (await backup.exists()) {
      await backup.delete(recursive: recursive);
    }

    final target = Directory(targetPath);
    if (await target.exists()) {
      await target.copy(backupPath, recursive: recursive);
      await target.delete(recursive: recursive);
    }

    try {
      await source.copy(targetPath, recursive: recursive);
    } catch (error) {
      await target.delete(recursive: recursive);
      await backup.copy(targetPath, recursive: recursive);
    }

    if (await backup.exists()) {
      await backup.delete(recursive: recursive);
    }
  }
}

extension DirectoryExtensions on Directory {
  Future<void> copy(String newPath, {bool recursive = false}) async {
    await Directory(newPath).create(recursive: true);

    await for (var entity in list(recursive: recursive)) {
      final relativePath = relative(entity.path, from: path);
      final entityNewPath = normalize(join(newPath, relativePath));
      switch (entity) {
        case File():
          await entity.copy(entityNewPath);
        case Directory():
          await Directory(entityNewPath).create(recursive: true);
      }
    }
  }
}
