import 'platform.dart';

class Assets {
  static const logo = 'assets/logo.png';
  static String get iconTray => switch (targetPlatform) {
    .windows => 'assets/icon_tray.ico',
    .macos => 'assets/icon_tray.png',
  };
}
