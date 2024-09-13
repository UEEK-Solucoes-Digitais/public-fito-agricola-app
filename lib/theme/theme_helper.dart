import 'package:flutter/material.dart';

import '../../core/app_export.dart';

/// Helper class for managing themes and colors.
class ThemeHelper {
  // The current app theme
  var _appTheme = PrefUtils().getThemeData();

// A map of custom color themes supported by the app
  Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };

// A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };

  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    //throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedCustomColor.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    //return theme from map

    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    //throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedColorScheme.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    //return theme from map

    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.h),
            side: BorderSide(
              color: colorScheme.primary,
              width: 1,
            ),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.blue5001,
      ),
    );
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 16.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 14.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 12.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: Color(0XFFFFFFFF),
          fontSize: 31.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 24.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        labelLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 13.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 9.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: Color(0XFF141414),
          fontSize: 16.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: appTheme.whiteA70001,
          fontSize: 15.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        displayMedium: TextStyle(
          color: Color(0xff424242),
          fontSize: 15.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          color: Color(0xff999999),
          fontSize: 14.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    // Primary colors
    primary: Color(0XFF064E43),
    secondary: Color(0XFF8ABB6E),

    // On colors(text colors)
    onPrimary: Color(0XFF3F4141),
    onPrimaryContainer: Color(0XFFF24646),
  );
}

/// Class containing custom colors for a primary theme.
class PrimaryColors {
  // Yellow

  // Amber
  Color get amber400 => Color(0XFFFFC020);
  Color get amber500 => Color(0XFFB5AE52);
  Color get amber550 => Color(0xffffc121);
  Color get amber50 => Color(0Xfffff1c9);

  // Blue ff006297
  Color get blue50 => Color(0XFFECF7FE);
  Color get blue5001 => Color(0XFFEDF7FE);
  Color get blue600 => Color(0Xff006297);

  // BlueGray
  Color get blueGray100 => Color(0XFFD0CCD0);

  // Gray
  Color get gray100 => Color(0XFFF2F2F2);
  Color get gray200 => Color(0Xff6d6d6e);
  Color get gray300 => Color(0XFFD9D9D9);
  Color get gray400 => Color(0XFF999999);
  Color get gray500 => Color(0XFF525252);
  Color get gray800 => Color(0XFF444444);
  Color get gray900 => Color(0XFF141414);

  // Black
  Color get black200 => Color(0Xff464646);
  Color get black300 => Color(0Xff373737);
  Color get black600 => Color(0Xff191919);

  // Green
  Color get green400 => Color(0XFF8ABB6E);
  Color get green50 => Color(0XFFE7FFE5);

  // LightBlue
  Color get lightBlueA100 => Color(0XFF63D9FF);

  // Teal
  Color get teal100 => Color(0XFFB2D1E6);

  // White
  Color get whiteA700 => Color(0XFFfafafa);
  Color get whiteA70001 => Color(0XFFFFFFFF);

  // Red
  Color get red300 => Color(0XFFfcdede);
  Color get red600 => Color(0XFFCC6363);

  // InputHints
  Color get hintPrimary => Color.fromARGB(179, 63, 65, 65);
}

PrimaryColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
