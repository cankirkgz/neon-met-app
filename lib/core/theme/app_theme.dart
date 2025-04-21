// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.scaffoldLight,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textLight),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.scaffoldLight,
          foregroundColor: AppColors.textLight,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.scaffoldDark,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textDark),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.scaffoldDark,
          foregroundColor: AppColors.textDark,
        ),
      );
}
