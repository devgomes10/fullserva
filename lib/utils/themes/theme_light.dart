import 'package:flutter/material.dart';
import 'package:fullserva/utils/themes/theme_colors.dart';
import 'package:fullserva/utils/themes/theme_fonts.dart';

ThemeData themeLight = ThemeData(
  primaryColor: ThemeColors.primary,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: ThemeColors.primarySwatch,
    backgroundColor: ThemeColors.secondary,
  ),
  textTheme: TextTheme(
    bodyLarge: ThemeFonts.primary,
    bodyMedium: ThemeFonts.primary,
    bodySmall: ThemeFonts.primary,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    titleTextStyle: ThemeFonts.secondary.copyWith(
      color: Colors.black87,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 8
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.black26),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // backgroundColor: ThemeColors.primary,
      // textStyle: ThemeFonts.primary.copyWith(color: Colors.white,),

    )
  )
);
