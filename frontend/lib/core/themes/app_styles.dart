// Example
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF41486d); // Teal
  static const Color primaryVariant = Color(0xFF006666);
  static const Color secondary = Color(0xFFFFA500); // Orange Accent
  static const Color secondaryVariant = Color(0xFFFF8C00);
  static const Color icon = Color(0xFFD0D0D0);

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color lightBlack = Color(0xFF5A5A5A);
  static const Color darkGrey = Color(0xFF414141);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkBlue = Color(0xFF41486D);

  // Background Colors
  static const Color background = Colors.white;
  static const Color surface = Colors.white;

  // Additional Colors
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.black;
  static const Color onBackground = Colors.black;
  static const Color onSurface = Colors.black;
  static const Color onError = Colors.white;
}

class AppFontSizes {
  static const double headline1 = 32.0;
  static const double headline6 = 20.0;
  static const double bodyText1 = 16.0;
  static const double bodyText2 = 14.0;
  static const double button = 18.0;
}

class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppBorders {
  static const BorderRadius small = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius large = BorderRadius.all(Radius.circular(16.0));
}
