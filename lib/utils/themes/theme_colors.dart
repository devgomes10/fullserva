import 'package:flutter/material.dart';

class ThemeColors {
  static const Color primary = Color(0xFF007DA6);
  static const Color secondary = Colors.white;
  static const Color tertiary = Color(0xFF808080);

  static MaterialColor primarySwatch = MaterialColor(
    ThemeColors.primary.value,
    const <int, Color>{
      50: ThemeColors.primary,
      100: ThemeColors.primary,
      200: ThemeColors.primary,
      300: ThemeColors.primary,
      400: ThemeColors.primary,
      500: ThemeColors.primary,
      600: ThemeColors.primary,
      700: ThemeColors.primary,
      800: ThemeColors.primary,
      900: ThemeColors.primary,
    },
  );
}