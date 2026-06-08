import 'package:flutter/material.dart';

class RemoteRiftColorScheme {
  RemoteRiftColorScheme({
    required this.neutral,
    required this.success,
    required this.warning,
    required this.error,
  });

  final Color neutral;
  final Color success;
  final Color warning;
  final Color error;

  factory RemoteRiftColorScheme.light() => RemoteRiftColorScheme(
    neutral: const .fromARGB(255, 92, 184, 227),
    success: const .fromARGB(255, 139, 195, 74),
    warning: const .fromARGB(255, 249, 199, 50),
    error: const .fromARGB(255, 235, 98, 88),
  );

  static RemoteRiftColorScheme? lerp(RemoteRiftColorScheme? a, RemoteRiftColorScheme? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null) {
      return t < 0.5 ? null : b;
    }
    if (b == null) {
      return t < 0.5 ? a : null;
    }
    return RemoteRiftColorScheme(
      neutral: .lerp(a.neutral, b.neutral, t)!,
      success: .lerp(a.success, b.success, t)!,
      warning: .lerp(a.warning, b.warning, t)!,
      error: .lerp(a.error, b.error, t)!,
    );
  }
}

enum RemoteRiftButtonVariant {
  large,
  medium,
  small;

  static RemoteRiftButtonVariant? lerp(
    RemoteRiftButtonVariant? a,
    RemoteRiftButtonVariant? b,
    double t,
  ) {
    return t <= 0.5 ? a : b;
  }
}
