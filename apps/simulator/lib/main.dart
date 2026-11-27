import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import 'i18n/strings.g.dart';
import 'ui/simulator_page.dart';

void main() {
  runApp(TranslationProvider(child: const RemoteRiftSimulatorApp()));
}

class const RemoteRiftSimulatorApp() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: t.appTitle,
      locale: TranslationProvider.of(context).flutterLocale,
      theme: RemoteRiftTheme.light(buttonVariant: .small),
      builder: (_, child) => RemoteRiftTheme.builder(child: child ?? const SizedBox.shrink()),
      home: SimulatorPage.builder(),
    );
  }
}
