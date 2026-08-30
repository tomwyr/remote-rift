import 'dart:io';

import 'package:path/path.dart';

import 'file_utils.dart';
import 'platform.dart';
import 'process_utils.dart';
import 'update_diagnostics.dart';
import 'update_journal_store.dart';

abstract class UpdateRunner({
  required final String _applicationLabel,
  final FileUtils _fileUtils = const FileUtils(),
  final ProcessUtils _processUtils = const ProcessUtils(),
  final UpdateDiagnostics _diagnostics = const UpdateDiagnostics(),
  final UpdateJournalStore _journalStore = const UpdateJournalStore(),
}) implements PlatformUpdateRunner {
  factory platform({
    required String applicationLabel,
    required String macosBundleName,
    required String windowsExecutableName,
  }) {
    return switch (targetPlatform) {
      .windows => WindowsUpdateRunner(
        applicationLabel: applicationLabel,
        executableName: windowsExecutableName,
      ),
      .macos => MacosUpdateRunner(
        applicationLabel: applicationLabel,
        bundleName: macosBundleName,
      ),
    };
  }

  Future<void> startProcess({
    required String archivePath,
    required String expectedVersion,
  }) async {
    final updaterDirectory = await Directory.systemTemp.createTemp('updater-helper-');
    final updaterPath = await _copyUpdater(updaterDirectory.path);
    final applicationDirectory = _fileUtils.getApplicationDirectory();

    final updateArgs = [
      archivePath,
      applicationDirectory,
      _applicationLabel,
      '$pid',
      expectedVersion,
      ...updateExtraArgs,
    ];
    await Process.start(updaterPath, updateArgs, workingDirectory: updaterDirectory.path);
  }

  Future<void> run({
    required String archivePath,
    required String applicationPath,
    required int parentPid,
    required String expectedVersion,
  }) async {
    final extractionPath = join(File(archivePath).parent.path, 'extracted');
    final paths = getUpdatePaths(extractionPath, applicationPath);

    final lock = File(join(dirname(applicationPath), '.$_applicationLabel-update.lock'));
    try {
      await lock.create(exclusive: true);
    } on FileSystemException {
      await _cleanupStaging(archivePath);
      return;
    }

    var replacementInstalled = false;
    try {
      if (!await _processUtils.waitForExit(processId: parentPid)) {
        return;
      }

      await _extractUpdate(
        zipPath: archivePath,
        outputPath: extractionPath,
        sourcePath: paths.source,
      );
      await _replaceTransaction(paths, expectedVersion);
      replacementInstalled = true;
      await runAppExecutable(paths.executable);
    } catch (_) {
      if (replacementInstalled) {
        await _restoreBackup(paths);
      }
      // The original app has exited. Relaunch the existing or restored application.
      await _diagnostics.record(event: 'helper_failed');
      await runAppExecutable(paths.executable);
      rethrow;
    } finally {
      if (await lock.exists()) {
        await lock.delete();
      }
      await _cleanupStaging(archivePath);
    }
  }

  Future<void> acknowledgeHealthyStart({required String version}) async {
    final path = _journalPath(_fileUtils.getApplicationDirectory());
    await _journalStore.acknowledge(path: path, currentVersion: version);
  }

  Future<void> cleanupArchive(String archivePath) async {
    await _cleanupStaging(archivePath);
  }

  Future<void> _extractUpdate({
    required String zipPath,
    required String outputPath,
    required String sourcePath,
  }) async {
    await _fileUtils.unzipFile(
      zipPath: zipPath,
      outputPath: outputPath,
      requiredRoot: expectedArchiveRoot,
    );
    if (!await validateExtractedSource(sourcePath)) {
      throw UpdateFileError.invalidArchive;
    }
  }

  Future<void> _replaceTransaction(UpdateRunnerPaths paths, String expectedVersion) async {
    final target = Directory(paths.target);
    final backup = Directory(paths.backup);
    final stagePath = '${paths.target}.update-${DateTime.now().microsecondsSinceEpoch}';
    final stage = Directory(stagePath);

    var targetMoved = false;
    try {
      await _fileUtils.copyDirectory(
        sourcePath: paths.source,
        targetPath: stage.path,
      );

      await _journalStore.write(
        path: _journalPath(paths.target),
        expectedVersion: expectedVersion,
        backupPath: paths.backup,
      );
      if (await backup.exists()) {
        await backup.delete(recursive: true);
      }

      if (await target.exists()) {
        await target.rename(paths.backup);
        targetMoved = true;
      }
      await stage.rename(paths.target);
    } catch (_) {
      if (targetMoved) {
        await _restoreBackup(paths);
      } else {
        await _journalStore.delete(_journalPath(paths.target));
      }
      rethrow;
    } finally {
      if (await stage.exists()) {
        await stage.delete(recursive: true);
      }
    }
  }

  Future<void> _restoreBackup(UpdateRunnerPaths paths) async {
    final target = Directory(paths.target);
    final backup = Directory(paths.backup);

    if (await target.exists()) {
      await target.delete(recursive: true);
    }
    if (await backup.exists()) {
      await backup.rename(paths.target);
    }
    await _journalStore.delete(_journalPath(paths.target));
  }

  String _journalPath(String applicationPath) {
    return join(dirname(applicationPath), '.$_applicationLabel-update.json');
  }

  Future<void> _cleanupStaging(String archivePath) async {
    final directory = File(archivePath).parent;
    if (basename(directory.path).startsWith('updater-update-') && await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  Future<String> _copyUpdater(String targetDirPath) async {
    final assetsDirectory = _fileUtils.getAssetsDirectory();
    final updaterPath = join(assetsDirectory, updaterFileName);
    final updater = File(updaterPath);
    if (!await updater.exists()) {
      throw UpdateFileError.updaterUnavailable;
    }
    final copyPath = join(targetDirPath, updaterFileName);
    final copy = await updater.copy(copyPath);
    if (targetPlatform == .macos) {
      final result = await Process.run('chmod', ['+x', copy.path]);
      if (result.exitCode != 0) {
        throw UpdateFileError.updaterUnavailable;
      }
    }
    return copy.path;
  }
}

abstract interface class PlatformUpdateRunner {
  String get updaterFileName;
  String? get expectedArchiveRoot;
  List<String> get updateExtraArgs;
  UpdateRunnerPaths getUpdatePaths(String sourcePath, String targetPath);
  Future<bool> validateExtractedSource(String sourcePath);
  Future<void> runAppExecutable(String executablePath);
}

class WindowsUpdateRunner({
  required super.applicationLabel,
  required final String _executableName,
}) extends UpdateRunner {
  @override
  String? get expectedArchiveRoot => null;

  @override
  List<String> get updateExtraArgs => [_executableName];

  @override
  String get updaterFileName => 'run_update.exe';

  @override
  UpdateRunnerPaths getUpdatePaths(String sourcePath, String targetPath) {
    return UpdateRunnerPaths(
      source: sourcePath,
      target: targetPath,
      backup: '$targetPath.bak',
      executable: join(targetPath, _executableName),
    );
  }

  @override
  Future<bool> validateExtractedSource(String sourcePath) {
    return File(join(sourcePath, _executableName)).exists();
  }

  @override
  Future<void> runAppExecutable(String executablePath) async {
    await Process.start(
      executablePath,
      [],
      workingDirectory: Directory.systemTemp.path,
    );
  }
}

class MacosUpdateRunner({
  required super.applicationLabel,
  required final String _bundleName,
}) extends UpdateRunner {
  @override
  String get expectedArchiveRoot => _bundleName;

  @override
  List<String> get updateExtraArgs => [_bundleName];

  @override
  String get updaterFileName => 'run_update';

  @override
  UpdateRunnerPaths getUpdatePaths(String sourcePath, String targetPath) {
    return UpdateRunnerPaths(
      source: join(sourcePath, _bundleName),
      target: targetPath,
      backup: '$targetPath.bak',
      executable: targetPath,
    );
  }

  @override
  Future<bool> validateExtractedSource(String sourcePath) {
    return Directory(sourcePath).exists();
  }

  @override
  Future<void> runAppExecutable(String executablePath) async {
    await Process.start('open', [executablePath], mode: .detached);
  }
}

class UpdateRunnerPaths({
  required final String source,
  required final String target,
  required final String backup,
  required final String executable,
});
