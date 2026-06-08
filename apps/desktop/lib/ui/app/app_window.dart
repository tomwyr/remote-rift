import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../common/platform.dart';

class AppWindow {
  static Future<void> configure() async {
    await windowManager.ensureInitialized();
    await Future.wait([
      windowManager.setAlignment(_resolveAlignment()),
      windowManager.setTitleBarStyle(_resolveTitleBarStyle()),
      windowManager.setSize(Size(300, 400)),
      windowManager.setResizable(false),
      windowManager.setPreventClose(true),
    ]);
    windowManager.addListener(AppWindowListener());
    windowManager.show();
  }

  static Alignment _resolveAlignment() {
    return switch (targetPlatform) {
      .windows => .bottomRight,
      .macos => .topRight,
    };
  }

  static TitleBarStyle _resolveTitleBarStyle() {
    return switch (targetPlatform) {
      .windows => .normal,
      .macos => .hidden,
    };
  }
}

class AppWindowListener with WindowListener {
  @override
  void onWindowClose() async {
    await windowManager.hide();
  }
}
