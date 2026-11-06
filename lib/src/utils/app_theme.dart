import 'package:flutter/material.dart';
import 'package:sleepfy/src/utils/constants.dart';

class AppTheme {
  // -------------------------------------------------------------
  // TEMA OSCURO (Slate Gris + Crema Orgánico)
  // -------------------------------------------------------------
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Constants.kDarkBackground,
      primaryColor: Constants.kDarkSecondary,
      colorScheme: const ColorScheme.dark(
        primary: Constants.kDarkSecondary,
        secondary: Constants.kSageGreen,
        surface: Constants.kDarkSurface,
        error: Constants.kErrorColor,
        onPrimary: Color(0xFF242C32),
        onSurface: Constants.kDarkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Constants.kDarkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Constants.kDarkTextPrimary),
        titleTextStyle: TextStyle(
          color: Constants.kDarkTextPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: Constants.kDarkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Constants.kDarkBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Constants.kDarkBorder,
        thickness: 1,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Constants.kDarkSecondary,
        textColor: Constants.kDarkTextPrimary,
      ),
    );
  }

  // -------------------------------------------------------------
  // TEMA CLARO (Crema Cálido + Slate Gris)
  // -------------------------------------------------------------
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Constants.kLightBackground,
      primaryColor: Constants.kLightPrimary,
      colorScheme: const ColorScheme.light(
        primary: Constants.kLightPrimary,
        secondary: Constants.kSageGreen,
        surface: Constants.kLightSurface,
        error: Constants.kErrorColor,
        onPrimary: Colors.white,
        onSurface: Constants.kLightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Constants.kLightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Constants.kLightTextPrimary),
        titleTextStyle: TextStyle(
          color: Constants.kLightTextPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: Constants.kLightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Constants.kLightBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Constants.kLightBorder,
        thickness: 1,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Constants.kLightPrimary,
        textColor: Constants.kLightTextPrimary,
      ),
    );
  }
}
