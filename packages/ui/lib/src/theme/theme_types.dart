import 'package:flutter/material.dart';

class RemoteRiftColorScheme {
  RemoteRiftColorScheme({
    required this.canvas,
    required this.navy,
    required this.panel,
    required this.gold,
    required this.cyan,
    required this.lightBlue,
    required this.ready,
    required this.neutral,
    required this.success,
    required this.warning,
    required this.error,
  });

  final Color canvas;
  final Color navy;
  final Color panel;
  final Color gold;
  final Color cyan;
  final Color lightBlue;
  final Color ready;
  final Color neutral;
  final Color success;
  final Color warning;
  final Color error;

  factory RemoteRiftColorScheme.light() => RemoteRiftColorScheme(
    canvas: const .fromARGB(255, 255, 255, 255),
    navy: const .fromARGB(255, 10, 20, 40),
    panel: const .fromARGB(255, 14, 27, 43),
    gold: const .fromARGB(255, 200, 170, 110),
    cyan: const .fromARGB(255, 10, 200, 185),
    lightBlue: const .fromARGB(255, 84, 199, 243),
    ready: const .fromARGB(255, 0, 114, 107),
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
      canvas: .lerp(a.canvas, b.canvas, t)!,
      navy: .lerp(a.navy, b.navy, t)!,
      panel: .lerp(a.panel, b.panel, t)!,
      gold: .lerp(a.gold, b.gold, t)!,
      cyan: .lerp(a.cyan, b.cyan, t)!,
      lightBlue: .lerp(a.lightBlue, b.lightBlue, t)!,
      ready: .lerp(a.ready, b.ready, t)!,
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
