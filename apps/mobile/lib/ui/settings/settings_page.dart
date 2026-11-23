import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';
import '../diagnostics/diagnostics_card.dart';

class const SettingsPage({super.key}) extends StatelessWidget {
  static void show(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title, style: titleStyle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const .fromLTRB(20, 16, 20, 16),
          children: [DiagnosticsCard.builder()],
        ),
      ),
    );
  }
}
