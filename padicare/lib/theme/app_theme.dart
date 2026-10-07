import 'package:flutter/material.dart';

class AgroColors {
  // Brand & Functional Roles
  static const Color primary = Color(0xFF133E26); // Deep Forest Green
  static const Color primaryContainer = Color(0xFF1B4D31);
  static const Color secondary = Color(0xFF2E7D32); // Fresh Leaf Vibrant Green
  static const Color secondaryContainer = Color(0xFFA0F399);
  static const Color onSecondaryContainer = Color(0xFF165B1D);

  // Background & Surfaces
  static const Color background = Color(0xFFF7F9F5); // Warm Paddy Off-White
  static const Color surface = Color(0xFFF7F9F5);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE8EFE5);
  static const Color outline = Color(0xFFE1E7DC);
  static const Color outlineDark = Color(0xFFC1C9C0);

  // Text Contrast Hierarchy
  static const Color textPrimary = Color(0xFF141E13); // Deep Peat Black-Green
  static const Color textSecondary = Color(0xFF414942); // Muted Foliage Slate
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textInverted = Color(0xFFFFFFFF);

  // Status Indicators
  static const Color healthy = Color(0xFF15803D);
  static const Color healthyBg = Color(0xFFDCFCE7);
  static const Color healthyBorder = Color(0xFF86EFAC);

  static const Color warning = Color(0xFFC2410C); // Warm Rust Orange
  static const Color warningBg = Color(0xFFFFEDD5);
  static const Color warningBorder = Color(0xFFFDBA74);

  static const Color uncertain = Color(0xFFB45309); // Slate Amber
  static const Color uncertainBg = Color(0xFFFEF3C7);
  static const Color uncertainBorder = Color(0xFFFCD34D);

  static const Color error = Color(0xFFB91C1C); // Burnt Red
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color errorBorder = Color(0xFFFCA5A5);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AgroColors.primary,
        primary: AgroColors.primary,
        secondary: AgroColors.secondary,
        surface: AgroColors.surface,
        error: AgroColors.error,
      ),
      scaffoldBackgroundColor: AgroColors.background,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: AgroColors.primary,
        foregroundColor: AgroColors.textInverted,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AgroColors.textInverted,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: AgroColors.textInverted),
      ),
      cardTheme: CardThemeData(
        color: AgroColors.cardSurface,
        elevation: 1,
        shadowColor: const Color(0x10141E13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AgroColors.outline, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AgroColors.primary,
          foregroundColor: AgroColors.textInverted,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AgroColors.primary,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: AgroColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: AgroColors.textPrimary,
          height: 1.25,
        ),
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AgroColors.textPrimary,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AgroColors.textPrimary,
          height: 1.35,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AgroColors.textPrimary,
          height: 1.35,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AgroColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AgroColors.textSecondary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AgroColors.textSecondary,
          height: 1.45,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AgroColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AgroColors.textSecondary,
        ),
      ),
    );
  }
}
