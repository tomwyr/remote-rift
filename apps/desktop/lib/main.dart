import 'package:flutter/material.dart';

import 'dependencies.dart';
import 'ui/app/app.dart';
import 'ui/app/app_tray.dart';
import 'ui/app/app_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await (AppWindow.configure(), AppTray.configure()).wait;

  final updater = Dependencies.applicationUpdater();
  await updater.acknowledgeHealthyStart();

  runApp(const App());
}
