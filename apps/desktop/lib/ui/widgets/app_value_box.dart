import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

class const AppValueBox({super.key, required final Widget child}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return Container(
      padding: .all(12),
      decoration: BoxDecoration(
        color: colors.navy.withValues(alpha: .04),
        border: .all(color: colors.navy.withValues(alpha: .12)),
        borderRadius: .circular(12),
      ),
      child: child,
    );
  }
}
