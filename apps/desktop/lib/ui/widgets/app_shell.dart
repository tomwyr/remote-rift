import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../common/assets.dart';
import '../../common/platform.dart';
import '../../i18n/strings.g.dart';
import '../update/update_button.dart';

class const DesktopAppShell({
  super.key,
  required final Widget body,
  final Widget? trailing,
  final bool showUpdateAction = true,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;
    final headerTopPadding = switch (targetPlatform) {
      .windows => 10.0,
      .macos => 34.0,
    };

    return Scaffold(
      backgroundColor: .alphaBlend(
        colors.navy.withValues(alpha: 0.018),
        colors.canvas,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: .fromLTRB(16, headerTopPadding, 12, 8),
              child: Row(
                children: [
                  Image.asset(Assets.logo, width: 40, height: 40),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t.app.title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontWeight: .w300),
                    ),
                  ),
                  ?trailing,
                  if (trailing != null && showUpdateAction) const SizedBox(width: 4),
                  if (showUpdateAction) UpdateButton.builder(),
                ],
              ),
            ),
            Expanded(
              child: Padding(padding: .all(12), child: body),
            ),
          ],
        ),
      ),
    );
  }
}
