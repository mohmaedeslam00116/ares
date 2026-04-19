import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette
  static const Color primaryColor = Color(0xFFE53935); // Mars Red
  static const Color backgroundColor = Color(0xFF121212); // Dark Surface
  static const Color surfaceColor = Color(0xFF1E1E1E); // Elevated Surface
  static const Color textColor = Color(0xFFE0E0E0); // Off-white

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSurface: textColor,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: textColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardTheme(
        color: surfaceColor,
        elevation: 2,
      ),
    );
  }
}
