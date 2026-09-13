import 'package:flutter/material.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';
import 'package:toastification/toastification.dart';

enum AppNotificationType { success, error }

class const AppNotifications({
  super.key,
  required final GlobalKey<NavigatorState> navigatorKey,
  required super.child,
}) extends InheritedWidget {
  static AppNotifications of(BuildContext context) {
    final notifications = context.getInheritedWidgetOfExactType<AppNotifications>();
    if (notifications == null) {
      throw StateError('AppNotifications is unavailable in this context.');
    }
    return notifications;
  }

  void show({
    required AppNotificationType type,
    required String title,
    required String description,
  }) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      return;
    }

    final context = navigator.context;
    final colors = context.remoteRiftTheme.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final icon = switch (type) {
      .success => Icons.check_rounded,
      .error => Icons.error_outline_rounded,
    };
    final color = switch (type) {
      .success => colors.success,
      .error => colors.error,
    };

    toastification.show(
      context: context,
      alignment: .topRight,
      autoCloseDuration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 200),
      type: switch (type) {
        .success => .success,
        .error => .error,
      },
      style: .flat,
      icon: Icon(icon, color: color, size: 22),
      primaryColor: color,
      backgroundColor: colors.canvas,
      foregroundColor: colors.navy,
      title: Text(
        title,
        style: textTheme.titleSmall?.copyWith(fontWeight: .w600),
      ),
      description: Text(
        description,
        style: textTheme.bodySmall?.copyWith(height: 1.42),
      ),
      padding: const .all(16),
      margin: const .all(12),
      borderRadius: .circular(16),
      borderSide: BorderSide(color: colors.navy.withValues(alpha: 0.12)),
      boxShadow: [
        BoxShadow(
          color: colors.navy.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
    );
  }

  @override
  bool updateShouldNotify(AppNotifications oldWidget) => navigatorKey != oldWidget.navigatorKey;
}
