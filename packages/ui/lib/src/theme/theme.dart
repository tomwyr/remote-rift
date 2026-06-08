import 'package:flutter/material.dart';

import 'theme_extension.dart';
import 'theme_types.dart';

class RemoteRiftTheme {
  static ThemeData light({RemoteRiftButtonVariant buttonVariant = .medium}) {
    const white = Colors.white;
    const black = Colors.black;

    final buttonMinSize = RemoteRiftThemeExtension.buttonSize(buttonVariant);

    return ThemeData(
      extensions: [
        RemoteRiftThemeExtension(
          buttonVariant: buttonVariant,
          appBarLeadingPadding: .only(left: 8),
          colorScheme: .light(),
        ),
      ],
      colorSchemeSeed: white,
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        leadingWidth: 64,
        titleSpacing: 8,
        centerTitle: false,
        actionsPadding: .only(right: 8),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: white),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: black)),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          final color = states.contains(WidgetState.focused) ? black : Colors.grey;
          return TextStyle(color: color);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: black),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: white,
          minimumSize: buttonMinSize,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: black, minimumSize: buttonMinSize),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: black,
        selectionHandleColor: black,
        selectionColor: black.withValues(alpha: 0.15),
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
