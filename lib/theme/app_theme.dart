import 'package:flutter/material.dart';

class AppColors {
  static const Color sageGreen = Color(0xFF87A878);
  static const Color lightSageGreen = Color(0xFFB2C9A7);
  static const Color paleSageGreen = Color(0xFFDDEDD7);
  static const Color softBlue = Color(0xFF89B4CC);
  static const Color lightSoftBlue = Color(0xFFA8C5DA);
  static const Color paleSoftBlue = Color(0xFFD6E9F3);
  static const Color paleYellow = Color(0xFFF5E6C8);
  static const Color lightPaleYellow = Color(0xFFF9F0DC);
  static const Color background = Color(0xFFF8F6F0);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D3A2E);
  static const Color textMedium = Color(0xFF5A6B5B);
  static const Color textLight = Color(0xFF9EAD9F);
  static const Color correctGreen = Color(0xFF5CB85C);
  static const Color correctGreenLight = Color(0xFFD4EDDA);
  static const Color wrongRed = Color(0xFFE8735A);
  static const Color wrongRedLight = Color(0xFFFADDD8);
  static const Color timerOrange = Color(0xFFE8A45A);
  static const Color shadow = Color(0x1A2D3A2E);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.sageGreen,
          secondary: AppColors.softBlue,
          tertiary: AppColors.paleYellow,
          surface: AppColors.cardWhite,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textDark,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
          headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          headlineMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textMedium,
            height: 1.6,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textMedium,
            height: 1.5,
          ),
          labelLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.sageGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          iconTheme: IconThemeData(color: AppColors.textDark),
        ),
      );
}
