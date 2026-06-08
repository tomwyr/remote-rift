import 'package:flutter/material.dart';

import 'theme_types.dart';

class RemoteRiftThemeExtension extends ThemeExtension<RemoteRiftThemeExtension> {
  RemoteRiftThemeExtension({
    required this.buttonVariant,
    required this.appBarLeadingPadding,
    required this.colorScheme,
  });

  final RemoteRiftButtonVariant buttonVariant;
  final EdgeInsets appBarLeadingPadding;
  final RemoteRiftColorScheme colorScheme;

  static RemoteRiftThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<RemoteRiftThemeExtension>()!;
  }

  static Size buttonSize(RemoteRiftButtonVariant variant) {
    return switch (variant) {
      .large => Size(double.infinity, 48),
      .medium => Size(double.infinity, 44),
      .small => Size(double.infinity, 40),
    };
  }

  static TextStyle buttonTextStyle(RemoteRiftButtonVariant variant, ThemeData theme) {
    return switch (variant) {
      .large => theme.textTheme.titleMedium!,
      .medium => theme.textTheme.titleMedium!,
      .small => theme.textTheme.titleSmall!,
    };
  }

  @override
  ThemeExtension<RemoteRiftThemeExtension> copyWith({
    RemoteRiftButtonVariant? buttonVariant,
    EdgeInsets? appBarLeadingPadding,
    RemoteRiftColorScheme? colorScheme,
  }) {
    return RemoteRiftThemeExtension(
      buttonVariant: buttonVariant ?? this.buttonVariant,
      appBarLeadingPadding: appBarLeadingPadding ?? this.appBarLeadingPadding,
      colorScheme: colorScheme ?? this.colorScheme,
    );
  }

  @override
  ThemeExtension<RemoteRiftThemeExtension> lerp(RemoteRiftThemeExtension? other, double t) {
    return RemoteRiftThemeExtension(
      buttonVariant: .lerp(buttonVariant, other?.buttonVariant, t) ?? buttonVariant,
      appBarLeadingPadding:
          .lerp(appBarLeadingPadding, other?.appBarLeadingPadding, t) ?? appBarLeadingPadding,
      colorScheme: .lerp(colorScheme, other?.colorScheme, t) ?? colorScheme,
    );
  }

  @override
  Object get type => RemoteRiftThemeExtension;
}

extension BuildContextRemoteRiftTheme on BuildContext {
  RemoteRiftThemeExtension get remoteRiftTheme => RemoteRiftThemeExtension.of(this);
}
