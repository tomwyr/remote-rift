import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../i18n/strings.g.dart';
import '../home/home_page.dart';

class const App({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: t.app.title,
      theme: RemoteRiftTheme.light(),
      builder: (context, child) => RemoteRiftTheme.builder(child: child!),
      home: HomePage.builder(),
    );
  }
}
