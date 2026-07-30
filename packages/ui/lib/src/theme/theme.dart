import 'package:flutter/material.dart';

import 'theme_extension.dart';
import 'theme_types.dart';

class RemoteRiftTheme {
  static ThemeData light({RemoteRiftButtonVariant buttonVariant = .medium}) {
    final colors = RemoteRiftColorScheme.light();

    final buttonMinSize = RemoteRiftThemeExtension.buttonSize(buttonVariant);

    return ThemeData(
      extensions: [
        RemoteRiftThemeExtension(
          buttonVariant: buttonVariant,
          appBarLeadingPadding: .only(left: 8),
          colorScheme: colors,
        ),
      ],
      colorScheme: .light(
        primary: colors.navy,
        onPrimary: colors.canvas,
        secondary: colors.gold,
        onSecondary: colors.navy,
        surface: colors.canvas,
        onSurface: colors.navy,
        error: colors.error,
      ),
      scaffoldBackgroundColor: colors.canvas,
      textTheme: Typography.material2021().black.apply(
        bodyColor: colors.navy,
        displayColor: colors.navy,
        fontFamily: 'Inter',
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.navy,
        elevation: 0,
        leadingWidth: 64,
        titleSpacing: 8,
        centerTitle: false,
        actionsPadding: .only(right: 8),
      ),
      dividerTheme: DividerThemeData(color: colors.gold.withValues(alpha: 0.65)),
      cardTheme: CardThemeData(
        color: colors.canvas,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(16),
          side: .new(color: colors.navy.withValues(alpha: 0.12)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.canvas,
        modalBackgroundColor: colors.canvas,
        shape: const RoundedRectangleBorder(borderRadius: .vertical(top: .circular(28))),
        dragHandleColor: colors.gold,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: colors.canvas),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(borderSide: .new(color: colors.cyan, width: 2)),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          final color = states.contains(WidgetState.focused) ? colors.cyan : Colors.grey;
          return TextStyle(color: color);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.cyan),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.navy,
          foregroundColor: colors.canvas,
          minimumSize: buttonMinSize,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(12),
            side: .new(color: colors.navy),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.navy,
          minimumSize: buttonMinSize,
          side: .new(color: colors.navy.withValues(alpha: 0.55)),
          shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.navy,
        selectionHandleColor: colors.navy,
        selectionColor: colors.cyan.withValues(alpha: 0.2),
      ),
    );
  }

  static Widget builder(BuildContext context, Widget? child) {
    final theme = Theme.of(context);
    final themeExtension = RemoteRiftThemeExtension.of(context);

    final buttonTextStyle = WidgetStateProperty.all(
      RemoteRiftThemeExtension.buttonTextStyle(themeExtension.buttonVariant, theme),
    );

    final modifiedTheme = theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(titleTextStyle: theme.textTheme.headlineSmall),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: theme.elevatedButtonTheme.style!.copyWith(textStyle: buttonTextStyle),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: theme.outlinedButtonTheme.style!.copyWith(textStyle: buttonTextStyle),
      ),
    );

    return Theme(data: modifiedTheme, child: child!);
  }
}
