import 'package:flutter/material.dart';
import 'package:fullserva/utils/themes/theme_colors.dart';
import 'package:fullserva/utils/themes/theme_fonts.dart';

ThemeData themeLight = ThemeData(
    primaryColor: ThemeColors.primary,
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: ThemeColors.secondary,
    ),
    textTheme: TextTheme(
      bodyMedium: ThemeFonts.primary,
      titleMedium: ThemeFonts.secondary,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: ThemeFonts.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ));
