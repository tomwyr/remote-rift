import 'dart:io';

enum TargetPlatform { windows, macos }

TargetPlatform get targetPlatform {
  if (Platform.isWindows) return .windows;
  if (Platform.isMacOS) return .macos;
  throw UnsupportedError(
    'Unsupported platform. Supported operating systems are Windows and macOS.',
  );
}
