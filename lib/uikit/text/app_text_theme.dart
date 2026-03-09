import 'package:flutter/material.dart';

class AppTextTheme {
  static const _font = 'OpenSans';

  static const textTheme = TextTheme(
    // HEADLINES
    headlineLarge: TextStyle(
      fontFamily: _font,
      fontSize: 32,
      height: 40 / 32,
      fontWeight: FontWeight.w400,
    ),

    headlineMedium: TextStyle(
      fontFamily: _font,
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w400,
    ),

    headlineSmall: TextStyle(
      fontFamily: _font,
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w400,
    ),

    // TITLES
    titleLarge: TextStyle(
      fontFamily: _font,
      fontSize: 22,
      height: 28 / 22,
      fontWeight: FontWeight.w600,
    ),

    titleMedium: TextStyle(
      fontFamily: _font,
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w600,
    ),

    titleSmall: TextStyle(
      fontFamily: _font,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w600,
    ),

    // BODY
    bodyLarge: TextStyle(
      fontFamily: _font,
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w400,
    ),

    bodyMedium: TextStyle(
      fontFamily: _font,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w400,
    ),

    bodySmall: TextStyle(
      fontFamily: _font,
      fontSize: 12,
      height: 16 / 12,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
    ),

    // LABEL
    labelLarge: TextStyle(
      fontFamily: _font,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w600,
    ),

    labelMedium: TextStyle(
      fontFamily: _font,
      fontSize: 12,
      height: 1.2,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w600,
    ),

    labelSmall: TextStyle(
      fontFamily: _font,
      fontSize: 11,
      height: 16 / 11,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w600,
    ),
  );
}
