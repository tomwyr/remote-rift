import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../../app_manager.dart';
import '../../common/assets.dart';
import '../../i18n/strings.g.dart';

class AppTray {
  static Future<void> configure() async {
    await Future.wait([
      trayManager.setIcon(Assets.iconTray),
      trayManager.setContextMenu(_createMenu()),
    ]);
    trayManager.addListener(AppTrayListener());
  }

  static Menu _createMenu() {
    return Menu(
      items: [
        MenuItem(key: AppTrayEntry.open.name, label: t.tray.openLabel),
        MenuItem.separator(),
        MenuItem(key: AppTrayEntry.quit.name, label: t.tray.quitLabel),
      ],
    );
  }
}

class AppTrayListener with TrayListener {
  @override
  void onTrayIconMouseDown() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key case var key?) {
      switch (AppTrayEntry.fromKey(key)) {
        case .open:
          windowManager.show();
        case .quit:
          appManager.exit();
      }
    }
  }
}

enum AppTrayEntry {
  open,
  quit;

  static AppTrayEntry fromKey(String key) {
    return values.firstWhere((enumCase) => enumCase.name == key);
  }
}
