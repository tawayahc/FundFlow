import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryVariant,
      surface: AppColors.surface,
      onError: AppColors.onError,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      brightness: Brightness.light,
    );

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: colorScheme.copyWith(
        surface: AppColors.background,
      ),
      textTheme: GoogleFonts.notoSansThaiTextTheme(const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppFontSizes.headline1,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: AppFontSizes.headline6,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: AppFontSizes.bodyText1,
          color: AppColors.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: AppFontSizes.bodyText2,
          color: AppColors.grey,
        ),
        labelLarge: TextStyle(
          fontSize: AppFontSizes.button,
          color: AppColors.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      )),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.medium,
        ),
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: AppBorders.small,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorders.small,
          borderSide: BorderSide(color: AppColors.primary),
        ),
        labelStyle: TextStyle(
          color: AppColors.grey,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      primary: AppColors.primaryVariant,
      primaryContainer: AppColors.primary,
      secondary: AppColors.secondaryVariant,
      secondaryContainer: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
      onError: AppColors.onError,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      brightness: Brightness.dark,
    );

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryVariant,
      colorScheme: colorScheme.copyWith(
        surface: Colors.black,
      ),
      textTheme: GoogleFonts.notoSansThaiTextTheme(const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppFontSizes.headline1,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: AppFontSizes.headline6,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: AppFontSizes.bodyText1,
          color: AppColors.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: AppFontSizes.bodyText2,
          color: AppColors.grey,
        ),
        labelLarge: TextStyle(
          fontSize: AppFontSizes.button,
          color: AppColors.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      )),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primaryVariant,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.medium,
        ),
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: AppBorders.small,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorders.small,
          borderSide: BorderSide(color: AppColors.primaryVariant),
        ),
        labelStyle: TextStyle(
          color: AppColors.grey,
        ),
      ),
    );
  }
}
