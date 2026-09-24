import 'dart:io';

class GameClientLauncher {
  Future<void> launch() async {
    final launcher = _launcherForPlatform();
    if (await FileSystemEntity.type(launcher.entryPoint) == .notFound) {
      throw GameClientLaunchError.launcherMissing;
    }

    try {
      await Process.start(launcher.executable, launcher.arguments, mode: .detached);
    } catch (error) {
      if (error case ProcessException() || FileSystemException()) {
        throw GameClientLaunchError.processStartFailed;
      }
      rethrow;
    }
  }

  _GameClientLaunchCommand _launcherForPlatform() {
    if (Platform.isWindows) {
      return (
        executable: r'C:\Riot Games\Riot Client\RiotClientServices.exe',
        entryPoint: r'C:\Riot Games\Riot Client\RiotClientServices.exe',
        arguments: ['--launch-product=league_of_legends', '--launch-patchline=live'],
      );
    }
    if (Platform.isMacOS) {
      return (
        executable: '/usr/bin/open',
        entryPoint: '/Applications/League of Legends.app',
        arguments: ['/Applications/League of Legends.app'],
      );
    }
    throw GameClientLaunchError.unsupportedPlatform;
  }
}

typedef _GameClientLaunchCommand = ({
  String executable,
  String entryPoint,
  List<String> arguments,
});

enum GameClientLaunchError implements Exception {
  unsupportedPlatform,
  launcherMissing,
  processStartFailed,
}
