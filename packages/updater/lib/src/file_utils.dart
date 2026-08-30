import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart';

import 'platform.dart';

class const FileUtils() {
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

  Future<String> unzipFile({
    required String zipPath,
    required String outputPath,
    String? requiredRoot,
    int maxEntries = 20000,
    int maxUncompressedBytes = 4 * 1024 * 1024 * 1024,
  }) async {
    final archive = await _readArchive(zipPath);

    _validateArchive(
      archive: archive,
      outputPath: outputPath,
      requiredRoot: requiredRoot,
      maxEntries: maxEntries,
      maxUncompressedBytes: maxUncompressedBytes,
    );

    return await _writeArchive(outputPath, archive);
  }

  Future<void> copyDirectory({
    required String sourcePath,
    required String targetPath,
  }) async {
    final source = Directory(sourcePath);
    final target = Directory(targetPath);
    await target.create(recursive: true);

    await for (var entity in source.list(recursive: true)) {
      final relativePath = relative(entity.path, from: source.path);
      final destination = join(target.path, relativePath);
      switch (entity) {
        case File():
          final destinationFile = File(destination);
          await destinationFile.parent.create(recursive: true);
          await entity.copy(destinationFile.path);
        case Directory():
          await Directory(destination).create(recursive: true);
      }
    }
  }

  Future<Archive> _readArchive(String zipPath) async {
    if (!zipPath.endsWith('.zip')) {
      throw UpdateFileError.invalidArchive;
    }
    final zip = File(zipPath);
    if (!await zip.exists()) {
      throw UpdateFileError.invalidArchive;
    }
    final input = InputFileStream(zipPath);
    try {
      return ZipDecoder().decodeStream(input);
    } finally {
      await input.close();
    }
  }

  void _validateArchive({
    required Archive archive,
    required String outputPath,
    required String? requiredRoot,
    required int maxEntries,
    required int maxUncompressedBytes,
  }) {
    if (archive.length > maxEntries) {
      throw UpdateFileError.invalidArchive;
    }

    var totalSize = 0;
    for (final entry in archive) {
      if (entry.name.isEmpty || isAbsolute(entry.name) || entry.isSymbolicLink) {
        throw UpdateFileError.invalidArchive;
      }

      final destination = normalize(join(outputPath, entry.name));
      if (!isWithin(outputPath, destination)) {
        throw UpdateFileError.invalidArchive;
      }

      if (requiredRoot case var root?) {
        final rootPath = normalize(join(outputPath, root));
        if (destination != rootPath && !isWithin(rootPath, destination)) {
          throw UpdateFileError.invalidArchive;
        }
      }

      totalSize += entry.size;
      if (totalSize > maxUncompressedBytes) {
        throw UpdateFileError.invalidArchive;
      }
    }
  }

  Future<String> _writeArchive(String outputPath, Archive archive) async {
    await Directory(outputPath).create(recursive: true);
    await extractArchiveToDisk(archive, outputPath);
    return outputPath;
  }
}

enum UpdateFileError implements Exception {
  invalidArchive,
  invalidInput,
  updaterUnavailable,
}
