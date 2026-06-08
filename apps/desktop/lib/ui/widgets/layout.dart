import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

class BasicLayout extends StatelessWidget {
  const BasicLayout({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.loading = false,
    this.action,
    this.secondaryAction,
  });

  final String? title;
  final String? description;
  final BasicLayoutIcon? icon;
  final bool loading;
  final BasicLayoutAction? action;
  final BasicLayoutAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      textAlign: .center,
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisAlignment: .center,
        children: [
          if (icon case var icon?) _icon(icon),
          if (title != null || description != null) SizedBox(height: 8),
          if (title case var title?)
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (title != null && description != null) SizedBox(height: 2),
          if (description case var description?) ...[Text(description)],
          if (loading) ...[
            SizedBox(height: 16),
            Center(
              child: CircularProgressIndicator(
                constraints: .tight(.square(24)),
                strokeWidth: 3,
              ),
            ),
          ] else ...[
            if (action != null || secondaryAction != null) SizedBox(height: 8),
            if (action case BasicLayoutAction(:var label, :var onPressed)) ...[
              SizedBox(height: 8),
              ElevatedButton(onPressed: onPressed, child: Text(label)),
            ],
            if (secondaryAction case BasicLayoutAction(
              :var label,
              :var onPressed,
            )) ...[
              SizedBox(height: 8),
              OutlinedButton(onPressed: onPressed, child: Text(label)),
            ],
          ],
        ],
      ),
    );
  }

  Widget _icon(BasicLayoutIcon icon) {
    Widget child = Icon(icon.data, size: 40, color: icon.color);

    if (icon.offset case var offset?) {
      child = Transform.translate(offset: offset, child: child);
    }

    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: .all(10),
        decoration: BoxDecoration(
          shape: .circle,
          color: .alphaBlend(icon.color.withValues(alpha: 0.15), Colors.white),
        ),
        child: child,
      ),
    );
  }
}

class BasicLayoutIcon {
  BasicLayoutIcon({required this.data, required this.color, this.offset});

  factory BasicLayoutIcon.warning(RemoteRiftColorScheme colorScheme) {
    return .new(
      data: Icons.warning_amber_rounded,
      color: colorScheme.warning,
      offset: Offset(0, -2),
    );
  }

  factory BasicLayoutIcon.error(RemoteRiftColorScheme colorScheme) {
    return .new(data: Icons.error_outline_rounded, color: colorScheme.error);
  }

  factory BasicLayoutIcon.update(RemoteRiftColorScheme colorScheme) {
    return .new(data: Icons.system_update_alt, color: colorScheme.success);
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
