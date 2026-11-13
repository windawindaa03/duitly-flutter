import 'package:flutter/material.dart';

/// Konfigurasi Tema dan Palet Warna Aplikasi Duitly
/// Menggunakan konsep Minimalis, Modern, Rapi, dan Material Design 3.
class AppTheme {
  // Palet Warna Resmi Duitly
  static const Color navy = Color(0xFF233B63);
  static const Color blue = Color(0xFF4779B8);
  static const Color background = Color(0xFFF4F6F9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color income = Color(0xFF16A477);
  static const Color expense = Color(0xFFE56B70);
  static const Color mainText = Color(0xFF252B36);
  static const Color secondaryText = Color(0xFF7A8494);

  // Tema Aplikasi Flutter
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: navy,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: navy,
        onPrimary: white,
        secondary: blue,
        onSecondary: white,
        surface: white,
        onSurface: mainText,
        error: expense,
        onError: white,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: mainText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: mainText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: mainText),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.04), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: secondaryText, fontSize: 14),
        labelStyle: const TextStyle(color: secondaryText, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryText.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryText.withValues(alpha: 0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: expense, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: expense, width: 2),
        ),
      ),
    );
  }
}
