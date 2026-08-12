import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import 'fit_viewport_scroll_view.dart';

class const BasicLayout({
  super.key,
  final String? title,
  final String? description,
  final Widget? body,
  final bool loading = false,
  final RiftStatusTone tone = .neutral,
  final IconData? icon,
  final BasicLayoutAction? action,
  final BasicLayoutAction? secondaryAction,
}) extends StatelessWidget {
  this
    : assert(
        title != null || description == null,
        'Description must not be provided unless the title is set.',
      );

  @override
  Widget build(BuildContext context) {
    return FitViewportScrollView(
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .spaceBetween,
        children: [_topContent(context), ?_bottomContent(context)],
      ),
    );
  }

  Widget _topContent(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (title case var title?)
          BasicLayoutSection(
            title: title,
            titleFontSize: .large,
            description: description,
            tone: tone,
            icon: icon,
          ),
        if (body case var body?) ...[SizedBox(height: 12), body],
      ],
    );
  }

  Widget? _bottomContent(BuildContext context) {
    final hasAction = action != null || secondaryAction != null;

    if (!loading && !hasAction) return null;

    return Column(
      crossAxisAlignment: .start,
      children: [
        SizedBox(height: 12),
        if (loading)
          Center(child: CircularProgressIndicator())
        else if (hasAction) ...[
          if (action case BasicLayoutAction(:var label, :var onPressed)) ...[
            SizedBox(height: 12),
            ElevatedButton(onPressed: onPressed, child: Text(label)),
          ],
          if (secondaryAction case BasicLayoutAction(
            :var label,
            :var onPressed,
          )) ...[
            SizedBox(height: 12),
            OutlinedButton(onPressed: onPressed, child: Text(label)),
          ],
        ],
        SizedBox(height: 12),
      ],
    );
  }
}

class BasicLayoutAction({
  required final String label,
  required final VoidCallback? onPressed,
});

enum RiftStatusTone { neutral, active, ready, warning, error }

enum BasicLayoutSectionFontSize { medium, large }

class const BasicLayoutSection({
  super.key,
  final String? label,
  final String? title,
  final Widget? titlePlaceholder,
  final BasicLayoutSectionFontSize titleFontSize = .medium,
  final String? description,
  final RiftStatusTone tone = .neutral,
  final IconData? icon,
}) extends StatelessWidget {
  this
    : assert(
        title != null || titlePlaceholder != null,
        'Either the title or title placeholder must be provided.',
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final colors = context.remoteRiftTheme.colorScheme;
    final accent = switch (tone) {
      .neutral => colors.gold,
      .active => colors.cyan,
      .ready => colors.ready,
      .warning => colors.warning,
      .error => colors.error,
    };

    return Container(
      width: .infinity,
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.navy.withValues(alpha: 0.025),
        border: .all(color: colors.navy.withValues(alpha: 0.12)),
        borderRadius: .circular(16),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          if (label case var label?)
            Text(
              label.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(
                color: colors.navy.withValues(alpha: 0.72),
                fontWeight: .w800,
                letterSpacing: 1.2,
              ),
            ),
          if (label != null) const SizedBox(height: 8),
          if (title case var title?)
            Row(
              crossAxisAlignment: .start,
              children: [
                if (icon case var icon?) ...[
                  _StatusSectionIcon(icon: icon, color: accent),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: switch (titleFontSize) {
                      .medium => textTheme.titleLarge,
                      .large => textTheme.headlineMedium,
                    },
                  ),
                ),
              ],
            )
          else if (titlePlaceholder case var titleWidget?) ...[
            const SizedBox(height: 2),
            titleWidget,
          ],
          if (description case var description?) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: textTheme.bodyLarge?.copyWith(height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}

class const _StatusSectionIcon({
  required final IconData icon,
  required final Color color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: .circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
