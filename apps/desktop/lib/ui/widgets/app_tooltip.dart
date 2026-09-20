import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

class const AppTooltip({
  required final String message,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return Tooltip(
      message: message,
      preferBelow: false,
      verticalOffset: 8,
      positionDelegate: (context) => positionDependentBox(
        size: context.overlaySize,
        childSize: context.tooltipSize,
        target: context.target,
        preferBelow: false,
        verticalOffset: 8,
        margin: 0,
      ),
      padding: const .symmetric(horizontal: 12, vertical: 8),
      margin: const .all(4),
      decoration: BoxDecoration(
        color: colors.canvas,
        border: .all(color: colors.navy.withValues(alpha: 0.12)),
        borderRadius: .circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.navy.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      textStyle: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: colors.navy, height: 1.42),
      child: child,
    );
  }
}
