import 'dart:io';

import 'package:path/path.dart' as path;

import 'file_utils.dart';
import 'platform.dart';

abstract class UpdateRunner implements PlatformUpdateRunner {
  UpdateRunner({required this.applicationLabel, required this.fileUtils});

  factory UpdateRunner.platform({
    required String applicationLabel,
    required String macosBundleName,
    required String windowsExecutableName,
    FileUtils fileUtils = const FileUtils(),
  }) {
    return switch (targetPlatform) {
      .windows => WindowsUpdateRunner(
        applicationLabel: applicationLabel,
        executableName: windowsExecutableName,
        fileUtils: fileUtils,
      ),
      .macos => MacosUpdateRunner(
        applicationLabel: applicationLabel,
        bundleName: macosBundleName,
        fileUtils: fileUtils,
      ),
    };
  }

  final String applicationLabel;
  final FileUtils fileUtils;

  Future<void> startProcess({required String archivePath}) async {
    final applicationPath = fileUtils.getApplicationDirectory();
    final updateDirPath = Directory.systemTemp.path;
    final updaterPath = await _copyUpdater(updateDirPath);

    final updateArgs = [
      archivePath,
      applicationPath,
      applicationLabel,
      ...updateExtraArgs,
    ];

    await Process.start(
      updaterPath,
      updateArgs,
      workingDirectory: updateDirPath,
    );
  }

  Future<void> run({
    required String archivePath,
    required String applicationPath,
  }) async {
    // Wait to ensure the app has fully quit before replacing
    await Future.delayed(Duration(seconds: 1));

    final unzippedPath = await fileUtils.unzipFile(archivePath);
    final paths = getUpdatePaths(unzippedPath, applicationPath);

    await fileUtils.replaceWithBackup(
      sourcePath: paths.source,
      targetPath: paths.target,
      backupPath: paths.backup,
      recursive: true,
    );

    await runAppExecutable(paths.executable);
  }

  Future<String> _copyUpdater(String targetDirPath) async {
    final assetsPath = fileUtils.getAssetsDirectory();
    final updaterPath = path.join(assetsPath, updaterFileName);

    final updater = File(updaterPath);
    if (!await updater.exists()) {
      throw Exception('Updater executable not found at path: $updaterPath');
    }

    final updateTempPath = path.join(
      targetDirPath,
      '${applicationLabel}_$updaterFileName',
    );
    await updater.copy(updateTempPath);
    return updateTempPath;
  }
}

abstract interface class PlatformUpdateRunner {
  String get updaterFileName;
  List<String> get updateExtraArgs;
  UpdateRunnerPaths getUpdatePaths(String sourcePath, String targetPath);
  Future<void> runAppExecutable(String executablePath);
}

class WindowsUpdateRunner extends UpdateRunner {
  WindowsUpdateRunner({
    required super.applicationLabel,
    required this.executableName,
    super.fileUtils = const FileUtils(),
  });

  final String executableName;

  @override
  List<String> get updateExtraArgs => [executableName];

  @override
  String get updaterFileName => 'run_update.exe';

  @override
  UpdateRunnerPaths getUpdatePaths(String sourcePath, String targetPath) {
    return .new(
      source: sourcePath,
      target: targetPath,
      backup: '$targetPath.bak',
      executable: path.join(targetPath, executableName),
    );
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

class MacosUpdateRunner extends UpdateRunner {
  MacosUpdateRunner({
    required super.applicationLabel,
    required this.bundleName,
    super.fileUtils = const FileUtils(),
  });

  final String bundleName;

  @override
  String get updaterFileName => 'run_update';

  @override
  List<String> get updateExtraArgs => [bundleName];

  @override
  UpdateRunnerPaths getUpdatePaths(String sourcePath, String targetPath) {
    return .new(
      source: path.join(sourcePath, bundleName),
      target: targetPath,
      backup: '$targetPath.bak',
      executable: targetPath,
    );
  }

  @override
  Future<void> runAppExecutable(String executablePath) async {
    await Process.start('open', [executablePath], mode: .detached);
  }
}

class UpdateRunnerPaths {
  UpdateRunnerPaths({
    required this.source,
    required this.target,
    required this.backup,
    required this.executable,
  });

  final String source;
  final String target;
  final String backup;
  final String executable;
}
