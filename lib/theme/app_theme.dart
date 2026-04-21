import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ==========================================
// ARES Design System - Single Source of Truth
// ==========================================

// Color Palette - Light Theme
class LightColors {
  static const Color primary = Color(0xFFE53935);
  static const Color primaryLight = Color(0xFFFF6F60);
  static const Color primaryDark = Color(0xFFAB000D);

  static const Color background = Color(0xFFF5F5F5);
  static const Color scaffoldBackground = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF0F0F0);
  static const Color surfaceOverlay = Color(0xFFE8E8E8);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundCompleted = Color(0xFFF5F5F5);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textHint = Color(0xFFAAAAAA);

  static const Color divider = Color(0xFFE0E0E0);
}

// Color Palette - Dark Theme
class DarkColors {
  static const Color primary = Color(0xFFE53935);
  static const Color primaryLight = Color(0xFFFF6F60);
  static const Color primaryDark = Color(0xFFAB000D);

  static const Color background = Color(0xFF0D0D0D);
  static const Color scaffoldBackground = Color(0xFF121212);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF242424);
  static const Color surfaceOverlay = Color(0xFF2D2D2D);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color cardBackgroundCompleted = Color(0xFF252525);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF757575);
  static const Color textHint = Color(0xFF757575);

  static const Color divider = Color(0xFF2C2C2D);
}

// App Colors (Dynamic)
class AppColors {
  // Brand Colors
  static const Color primary = DarkColors.primary;
  static const Color primaryLight = DarkColors.primaryLight;
  static const Color primaryDark = DarkColors.primaryDark;

  // Background Colors (will be overridden by theme)
  static const Color background = DarkColors.background;
  static const Color scaffoldBackground = DarkColors.scaffoldBackground;
  static const Color surface = DarkColors.surface;
  static const Color surfaceElevated = DarkColors.surfaceElevated;
  static const Color surfaceOverlay = DarkColors.surfaceOverlay;
  static const Color cardBackground = DarkColors.cardBackground;
  static const Color cardBackgroundCompleted = DarkColors.cardBackgroundCompleted;

  // Text Colors
  static const Color textPrimary = DarkColors.textPrimary;
  static const Color textSecondary = DarkColors.textSecondary;
  static const Color textTertiary = DarkColors.textTertiary;
  static const Color textHint = DarkColors.textHint;

  // Priority Colors
  static const Color priorityHigh = Color(0xFFE53935);
  static const Color priorityMedium = Color(0xFFFFA726);
  static const Color priorityLow = Color(0xFF66BB6A);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // UI Element Colors
  static const Color divider = DarkColors.divider;
  static const Color checkboxBorder = Color(0xFFBDBDBD);
  static const Color checkboxBackground = Color(0xFFEEEEEE);
  static const Color ripple = Color(0x1AFFFFFF);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFFE53935),
    Color(0xFFFF7043),
  ];

  // Helper methods
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return priorityHigh;
      case 'low':
        return priorityLow;
      case 'medium':
      default:
        return priorityMedium;
    }
  }

  static String getPriorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'High';
      case 'low':
        return 'Low';
      case 'medium':
      default:
        return 'Medium';
    }
  }
}

// Spacing System
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: md, vertical: 14);
}

// Border Radius
class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 100;

  static BorderRadius get cardRadius => BorderRadius.circular(md);
  static BorderRadius get inputRadius => BorderRadius.circular(md);
  static BorderRadius get buttonRadius => BorderRadius.circular(md);
  static BorderRadius get chipRadius => BorderRadius.circular(lg);
}

// Shadows
class AppShadows {
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}

// Main Theme
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: DarkColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: DarkColors.scaffoldBackground,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: DarkColors.textPrimary,
        displayColor: DarkColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DarkColors.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: DarkColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: DarkColors.textPrimary),
      ),
      cardTheme: CardTheme(
        color: DarkColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkColors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: AppSpacing.inputPadding,
        hintStyle: const TextStyle(color: DarkColors.textTertiary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: DarkColors.surfaceElevated,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: DarkColors.textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      dividerTheme: const DividerThemeData(
        color: DarkColors.divider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DarkColors.surfaceOverlay,
        contentTextStyle: GoogleFonts.inter(color: DarkColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: DarkColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: DarkColors.textPrimary,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: DarkColors.textSecondary,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: LightColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: LightColors.scaffoldBackground,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: LightColors.textPrimary,
        displayColor: LightColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: LightColors.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: LightColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: LightColors.textPrimary),
      ),
      cardTheme: CardTheme(
        color: LightColors.cardBackground,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LightColors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: AppSpacing.inputPadding,
        hintStyle: const TextStyle(color: LightColors.textTertiary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: LightColors.surfaceElevated,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: LightColors.textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      dividerTheme: const DividerThemeData(
        color: LightColors.divider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: LightColors.surfaceOverlay,
        contentTextStyle: GoogleFonts.inter(color: LightColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: LightColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: LightColors.textPrimary,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: LightColors.textSecondary,
        ),
      ),
    );
  }
}
