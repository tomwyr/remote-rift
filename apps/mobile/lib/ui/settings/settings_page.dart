import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../i18n/strings.g.dart';
import '../app/app_notifications.dart';
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
          children: [
            DiagnosticsCard.builder(),
            ListTile(
              title: Text(t.settings.privacyPolicy),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _openPrivacyPolicy(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final url = Uri.https('tomwyr.github.io', '/remote-rift/privacy.html');
    try {
      if (await launchUrl(url, mode: .externalApplication)) return;
    } on PlatformException {
      // Show the same feedback when the platform cannot launch a browser.
    }
    if (context.mounted) {
      AppNotifications.show(context, t.settings.privacyPolicyOpenFailed);
    }
  }
}
