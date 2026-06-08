import 'package:flutter/material.dart';

import 'ui/app/app.dart';
import 'ui/app/app_tray.dart';
import 'ui/app/app_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppWindow.configure();
  await AppTray.configure();

  runApp(const App());
}
