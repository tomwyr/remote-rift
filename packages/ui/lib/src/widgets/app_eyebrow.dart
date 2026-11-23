import 'package:flutter/material.dart';

import '../theme/theme_extension.dart';

class const AppEyebrow({
  super.key,
  required final String label,
  final Color? accent,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final text = Text(
      label.toUpperCase(),
      style: textTheme.labelSmall?.copyWith(
        color: colors.navy.withValues(alpha: 0.72),
        fontWeight: accent == null ? .w800 : .w600,
        letterSpacing: accent == null ? 1.2 : 1.15,
      ),
    );

    if (accent case var accent?) {
      return Row(
        spacing: 8,
        children: [
          SizedBox(width: 3, height: 16, child: ColoredBox(color: accent)),
          Flexible(child: text),
        ],
      );
    }
    return text;
  }
}
