import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds
  static const Color darkBg = Color(0xFF0F1219);
  static const Color cardDark = Color(0xFF1B202D);
  static const Color surfaceDark = Color(0xFF161B26);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF8A2BE2), // Blue Violet
    Color(0xFF2E5BFF), // Royal Blue
  ];

  static const List<Color> neonGradient = [
    Color(0xFF00F2FF), // Cyan
    Color(0xFF0061FF), // Intense Blue
  ];

  // Accents
  static const Color neonCyan = Color(0xFF00F2FF);
  static const Color neonPurple = Color(0xFFBD00FF);
  static const Color neonGreen = Color(0xFF00FFA3);

  // Text
  static const Color textHigh = Color(0xFFF1F3F5); // Off-white
  static const Color textMed = Color(0xFFA5ADB7);
  static const Color textLow = Color(0xFF636E7B);

  // Sentiment Colors
  static const Color positive = Color(0xFF00FFA3);
  static const Color neutral = Color(0xFF2E5BFF);
  static const Color negative = Color(0xFFFF4B2B);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF2E5BFF),
        secondary: AppColors.neonCyan,
        surface: AppColors.surfaceDark,
      ),
      textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: AppColors.textHigh,
          letterSpacing: -1,
        ),
        headlineMedium: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textHigh,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textHigh,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textMed,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
