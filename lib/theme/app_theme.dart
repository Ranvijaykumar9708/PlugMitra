import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - PlugMitra Emerald Green (Matching reference UI Board)
  static const Color primaryGreen = Color(0xFF00875A); // Deep emerald CTA
  static const Color vibrantGreen = Color(0xFF00C853); // Energetic charging green
  static const Color lightGreenBg = Color(0xFFE8F5E9); // Soft mint pill background
  static const Color borderGreen = Color(0xFFA5D6A7);

  // Surface & Background Colors (Clean, Modern, User-Friendly White Theme)
  static const Color bgLight = Color(0xFFF8FAFC);      // Off-white screen background
  static const Color cardWhite = Colors.white;         // Clean white cards
  static const Color borderLight = Color(0xFFE2E8F0);    // Subtle card divider/border
  static const Color inputBg = Color(0xFFF8FAFC);

  // Dark Charging Surfaces (Specifically for Screen 11 & 12 Cockpit HUD)
  static const Color chargingDark = Color(0xFF0D1B14);  // Immersive charging background
  static const Color chargingCard = Color(0xFF14241B);
  static const Color chargingBorder = Color(0xFF1E382B);

  // Status & Accent Colors
  static const Color electricMint = Color(0xFF00C853);
  static const Color electricCyan = Color(0xFF0284C7);
  static const Color neonVolt = Color(0xFF00C853);
  static const Color amberRating = Color(0xFFF59E0B);
  static const Color amberBusy = Color(0xFFFFB020);
  static const Color coralRed = Color(0xFFEF4444);

  // Backwards Compatibility Aliases
  static const Color bgDark = Color(0xFF0D1B14);
  static const Color surfaceDark = Color(0xFF14241B);
  static const Color cardDark = Colors.white;
  static const Color cardBorder = Color(0xFFE2E8F0);

  // High-Contrast User-Friendly Text Hierarchy
  static const Color textPrimary = Color(0xFF1E293B);   // Slate 800 (crisp, readable)
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8);     // Slate 400

  // Gradients
  static const LinearGradient mintCyanGradient = LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF00875A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0x2200C853), Color(0x0500875A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient chargingGlowGradient = LinearGradient(
    colors: [Color(0x3300C853), Color(0x0500C853)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: vibrantGreen,
        surface: cardWhite,
        error: coralRed,
      ),
      fontFamily: null,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
    );
  }

  // Alias for backward compatibility
  static ThemeData get darkTheme => lightTheme;
}
