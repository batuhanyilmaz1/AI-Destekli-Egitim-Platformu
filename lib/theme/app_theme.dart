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

  // Dark palette
  static const Color darkBg = Color(0xFF1A1F1A);
  static const Color darkCard = Color(0xFF242B24);
  static const Color darkSurface = Color(0xFF2D3A2E);
  static const Color darkTextPrimary = Color(0xFFE8EDE8);
  static const Color darkTextSecondary = Color(0xFF9DB09E);
  static const Color darkTextLight = Color(0xFF6A7D6B);
  static const Color darkShadow = Color(0x40000000);
  static const Color darkDivider = Color(0xFF344534);
}

extension ThemeContextX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get bgColor => isDark ? AppColors.darkBg : AppColors.background;
  Color get cardColor => isDark ? AppColors.darkCard : AppColors.cardWhite;
  Color get surfaceColor => isDark ? AppColors.darkSurface : AppColors.paleSageGreen;
  Color get primaryText => isDark ? AppColors.darkTextPrimary : AppColors.textDark;
  Color get secondaryText => isDark ? AppColors.darkTextSecondary : AppColors.textMedium;
  Color get lightText => isDark ? AppColors.darkTextLight : AppColors.textLight;
  Color get shadowColor => isDark ? AppColors.darkShadow : AppColors.shadow;
  Color get dividerColor => isDark ? AppColors.darkDivider : AppColors.paleSageGreen;
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

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.sageGreen,
          secondary: AppColors.softBlue,
          surface: AppColors.darkCard,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.darkTextPrimary,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.darkTextPrimary),
          displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.darkTextPrimary),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
          headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkTextSecondary, height: 1.6),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkTextSecondary, height: 1.5),
          labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.sageGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
          iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.darkCard,
          indicatorColor: AppColors.sageGreen.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkTextSecondary),
          ),
        ),
        dividerColor: AppColors.darkDivider,
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.sageGreen : AppColors.darkTextLight,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.sageGreen.withValues(alpha: 0.3) : AppColors.darkSurface,
          ),
        ),
      );
}
