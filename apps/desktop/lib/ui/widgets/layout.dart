import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

class BasicLayout extends StatelessWidget {
  const BasicLayout({
    super.key,
    required this.eyebrow,
    this.title,
    this.description,
    this.icon,
    this.tone = .neutral,
    this.loading = false,
    this.action,
    this.secondaryAction,
  });

  final String eyebrow;
  final String? title;
  final String? description;
  final BasicLayoutIcon? icon;
  final DesktopStatusTone tone;
  final bool loading;
  final BasicLayoutAction? action;
  final BasicLayoutAction? secondaryAction;

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

    return Align(
      alignment: .topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          width: .infinity,
          padding: .all(16),
          decoration: BoxDecoration(
            color: colors.canvas,
            border: Border.all(color: colors.navy.withValues(alpha: 0.12)),
            borderRadius: .circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.navy.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!,
            child: Column(
              crossAxisAlignment: .stretch,
              mainAxisSize: .min,
              children: [
                _StatusEyebrow(label: eyebrow, accent: accent, colors: colors),
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
        ),
      ),
    );
  }
}

class _StatusEyebrow extends StatelessWidget {
  const _StatusEyebrow({
    required this.label,
    required this.accent,
    required this.colors,
  });

  final String label;
  final Color accent;
  final RemoteRiftColorScheme colors;

  @override
  Widget build(BuildContext context) {
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

class _StatusDetails extends StatelessWidget {
  const _StatusDetails({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
  });

  final String? title;
  final String? description;
  final BasicLayoutIcon? icon;
  final Color accent;

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
        if ((title != null || icon != null) && description != null)
          const SizedBox(height: 10),
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

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.icon, required this.accent});

  final BasicLayoutIcon icon;
  final Color accent;

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

class _StatusFooter extends StatelessWidget {
  const _StatusFooter({
    required this.loading,
    required this.action,
    required this.secondaryAction,
  });

  final bool loading;
  final BasicLayoutAction? action;
  final BasicLayoutAction? secondaryAction;

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

class _StatusActions extends StatelessWidget {
  const _StatusActions({required this.action, required this.secondaryAction});

  final BasicLayoutAction? action;
  final BasicLayoutAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    if (action == null && secondaryAction == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (action case BasicLayoutAction(:final label, :final onPressed))
          ElevatedButton(onPressed: onPressed, child: Text(label)),
        if (secondaryAction case BasicLayoutAction(
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

enum DesktopStatusTone { neutral, active, ready, warning, error }

class BasicLayoutIcon {
  BasicLayoutIcon({required this.data, required this.color, this.offset});

  factory BasicLayoutIcon.warning(RemoteRiftColorScheme colorScheme) {
    return BasicLayoutIcon(
      data: Icons.warning_amber_rounded,
      color: colorScheme.warning,
      offset: const Offset(0, -2),
    );
  }

  factory BasicLayoutIcon.error(RemoteRiftColorScheme colorScheme) {
    return BasicLayoutIcon(
      data: Icons.error_outline_rounded,
      color: colorScheme.error,
    );
  }

  factory BasicLayoutIcon.update(RemoteRiftColorScheme colorScheme) {
    return BasicLayoutIcon(
      data: Icons.system_update_alt,
      color: colorScheme.success,
    );
  }

  final IconData data;
  final Color color;
  final Offset? offset;
}

class BasicLayoutAction {
  BasicLayoutAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;
}
