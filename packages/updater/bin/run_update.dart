import 'dart:io';

import 'package:remote_rift_updater/src/file_utils.dart';
import 'package:remote_rift_updater/src/platform.dart';
import 'package:remote_rift_updater/src/update_runner.dart';

void main(List<String> args) async {
  try {
    final archivePath = readArg(args, 0);
    final applicationPath = readArg(args, 1);
    final parentPid = int.tryParse(readArg(args, 3));
    if (parentPid == null || parentPid <= 0) {
      throw UpdateFileError.invalidInput;
    }
    final expectedVersion = readArg(args, 4);
    final runner = createRunner(args);
    await runner.run(
      archivePath: archivePath,
      applicationPath: applicationPath,
      parentPid: parentPid,
      expectedVersion: expectedVersion,
    );
  } on UpdateFileError catch (error) {
    _reportFailure(error);
  }
}

UpdateRunner createRunner(List<String> args) {
  final appLabel = readArg(args, 2);

  switch (targetPlatform) {
    case .windows:
      final executableName = readArg(args, 5);
      return WindowsUpdateRunner(
        applicationLabel: appLabel,
        executableName: executableName,
      );
    case .macos:
      final bundleName = readArg(args, 5);
      return MacosUpdateRunner(
        applicationLabel: appLabel,
        bundleName: bundleName,
      );
  }
}

String readArg(List<String> args, int index) {
  final path = args.elementAtOrNull(index);
  if (path == null) {
    throw UpdateFileError.invalidInput;
  }
  return path;
}

void _reportFailure(UpdateFileError error) {
  switch (error) {
    case .invalidArchive:
      stderr.writeln('The downloaded update archive is invalid.');
      stderr.writeln('The current application has been restarted. Download the update again.');
      exitCode = 65;

    case .invalidInput:
      stderr.writeln('Invalid updater arguments.');
      stderr.writeln(
        'Usage: run_update <archive-path> <application-path> <application-label> '
        '<parent-pid> <expected-version> <executable-or-bundle-name>',
      );
      stderr.writeln('Start the main application to install updates.');
      exitCode = 64;

    case .updaterUnavailable:
      stderr.writeln('The bundled updater executable is unavailable.');
      stderr.writeln('Reinstall the application and try again.');
      exitCode = 69;
  }
}
