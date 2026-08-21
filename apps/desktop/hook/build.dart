import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:path/path.dart' as path;
import 'package:remote_rift_desktop/common/platform.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final paths = resolvePaths(input);
    await buildExecutable(paths.updaterRoot);
    File(paths.builtExecutable).copySync(paths.assetTarget);
  });
}

Future<void> buildExecutable(String workingDirectory) async {
  final arguments = [
    'build',
    'cli',
    '--target=bin/run_update.dart',
    '-o',
    'build',
  ];
  final result = await Process.run(
    'dart',
    arguments,
    workingDirectory: workingDirectory,
  );
  if (result.exitCode == 0) {
    return;
  }

  stderr
    ..writeln(result.stdout)
    ..writeln(result.stderr);
  throw ProcessException(
    'dart',
    arguments,
    'Failed to build the updater executable.',
    result.exitCode,
  );
}

UpdaterBuildPaths resolvePaths(BuildInput input) {
  final rootPath = path.fromUri(input.packageRoot);
  final monorepoRoot = path.normalize(path.join(rootPath, '..', '..'));
  final updaterRoot = path.join(monorepoRoot, 'packages', 'updater');
  final updaterFileName = resolveUpdaterFileName();
  final builtExecutable = path.join(
    updaterRoot,
    'build',
    'bundle',
    'bin',
    updaterFileName,
  );
  final assetTarget = path.join(rootPath, 'assets', updaterFileName);
  return (
    updaterRoot: updaterRoot,
    builtExecutable: builtExecutable,
    assetTarget: assetTarget,
  );
}

/// Hardcode file names due to the hook script being unable to run with imports
/// from the updater package.
/// Keep in sync with file names in WindowsUpdateRunner and MacosUpdateRunner.
/// For the current values, see `packages/updater/lib/src/update_runner.dart`.
String resolveUpdaterFileName() {
  return switch (targetPlatform) {
    .windows => 'run_update.exe',
    .macos => 'run_update',
  };
}

typedef UpdaterBuildPaths = ({
  String updaterRoot,
  String builtExecutable,
  String assetTarget,
});
