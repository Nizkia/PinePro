import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    fontFamily: 'Poppins',

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    cardTheme: CardTheme(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shadowColor: Colors.black12,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,

      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.md,
      ),

      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),

      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    ),


    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    ),

    iconTheme: const IconThemeData(
      color: AppColors.primaryDark,
      size: 26,
    ),
  );
}
