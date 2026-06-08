import 'package:application_updater/src/platform.dart';
import 'package:application_updater/src/update_runner.dart';

void main(List<String> args) async {
  final archivePath = readArg(args, 0, 'archive path');
  final applicationPath = readArg(args, 1, 'application path');
  final runner = createRunner(args);
  await runner.run(archivePath: archivePath, applicationPath: applicationPath);
}

UpdateRunner createRunner(List<String> args) {
  final appLabel = readArg(args, 2, 'application label');

  switch (targetPlatform) {
    case .windows:
      final executableName = readArg(args, 3, 'Windows executable name');
      return WindowsUpdateRunner(applicationLabel: appLabel, executableName: executableName);
    case .macos:
      final bundleName = readArg(args, 3, 'macOS bundle name');
      return MacosUpdateRunner(applicationLabel: appLabel, bundleName: bundleName);
  }
}

String readArg(List<String> args, int index, String argDebugLabel) {
  final path = args.elementAtOrNull(index);
  if (path == null) {
    throw Exception('Input argument #$index ($argDebugLabel) missing');
  }
  return path;
}
