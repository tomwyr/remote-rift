import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

class const AppCard({
  super.key,
  required final EdgeInsets padding,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return Align(
      alignment: .topCenter,
      child: Container(
        width: .infinity,
        padding: padding,
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
        child: child,
      ),
    );
  }
}

class const AppStatusLayout({
  super.key,
  required final String eyebrow,
  final String? title,
  final String? description,
  final AppStatusIcon? icon,
  final AppStatusTone tone = .neutral,
  final bool loading = false,
  final AppStatusAction? action,
  final AppStatusAction? secondaryAction,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;
    final accent = switch (tone) {
      .neutral => colors.gold,
      .active => colors.cyan,
      .ready => colors.ready,
      .warning => colors.warning,
      .error => colors.error,
    };

    return AppCard(
      padding: .all(16),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            AppEyebrow(label: eyebrow, accent: accent),
            const SizedBox(height: 16),
            _StatusDetails(
              title: title,
              description: description,
              icon: icon,
              accent: accent,
            ),
            const SizedBox(height: 16),
            _StatusFooter(
              loading: loading,
              action: action,
              secondaryAction: secondaryAction,
            ),
          ],
        ),
      ),
    );
  }
}

class const AppEyebrow({
  required final String label,
  required final Color accent,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.remoteRiftTheme.colorScheme;

    return Row(
      children: [
        Container(width: 3, height: 16, color: accent),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.navy.withValues(alpha: 0.72),
            fontWeight: .w600,
            letterSpacing: 1.15,
          ),
        ),
      ],
    );
  }
}

class const _StatusDetails({
  required final String? title,
  required final String? description,
  required final AppStatusIcon? icon,
  required final Color accent,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        if (title case final title?)
          Row(
            crossAxisAlignment: .center,
            children: [
              if (icon case final icon?) ...[
                _StatusIcon(icon: icon, accent: accent),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: .w300),
                ),
              ),
            ],
          )
        else if (icon case final icon?)
          _StatusIcon(icon: icon, accent: accent),
        if ((title != null || icon != null) && description != null) const SizedBox(height: 10),
        if (description case final description?)
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.42, fontWeight: .w400),
          ),
      ],
    );
  }
}

class const _StatusIcon({
  required final AppStatusIcon icon,
  required final Color accent,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget child = Icon(icon.data, size: 22, color: icon.color);

    if (icon.offset case final offset?) {
      child = Transform.translate(offset: offset, child: child);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: .all(8),
      decoration: BoxDecoration(
        borderRadius: .circular(10),
        color: .alphaBlend(accent.withValues(alpha: 0.12), Colors.white),
        border: Border.all(color: accent.withValues(alpha: 0.34)),
      ),
      child: child,
    );
  }
}

class const _StatusFooter({
  required final bool loading,
  required final AppStatusAction? action,
  required final AppStatusAction? secondaryAction,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: 44,
        child: Center(
          child: CircularProgressIndicator(
            constraints: const .tightFor(width: 24, height: 24),
            strokeWidth: 3,
          ),
        ),
      );
    }

    return _StatusActions(action: action, secondaryAction: secondaryAction);
  }
}

class const _StatusActions({
  required final AppStatusAction? action,
  required final AppStatusAction? secondaryAction,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (action == null && secondaryAction == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (action case AppStatusAction(:final label, :final onPressed))
          ElevatedButton(onPressed: onPressed, child: Text(label)),
        if (secondaryAction case AppStatusAction(
          :final label,
          :final onPressed,
        )) ...[
          const SizedBox(height: 8),
          OutlinedButton(onPressed: onPressed, child: Text(label)),
        ],
      ],
    );
  }
}

enum AppStatusTone { neutral, active, ready, warning, error }

class AppStatusIcon({
  required final IconData data,
  required final Color color,
  final Offset? offset,
}) {
  factory warning(RemoteRiftColorScheme colorScheme) {
    return AppStatusIcon(
      data: Icons.warning_amber_rounded,
      color: colorScheme.warning,
      offset: const Offset(0, -2),
    );
  }

  factory error(RemoteRiftColorScheme colorScheme) {
    return AppStatusIcon(
      data: Icons.error_outline_rounded,
      color: colorScheme.error,
    );
  }

  factory update(RemoteRiftColorScheme colorScheme) {
    return AppStatusIcon(
      data: Icons.system_update_alt,
      color: colorScheme.success,
    );
  }
}

class AppStatusAction({
  required final String label,
  required final VoidCallback? onPressed,
});
