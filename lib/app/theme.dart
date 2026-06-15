import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color brandPrimary = Color(0xFF1E3A8A);
const Color brandSecondary = Color(0xFF0EA5E9);
const Color brandSurface = Color(0xFFF8FAFC);
const Color brandError = Color(0xFFDC2626);

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: brandPrimary,
    primary: brandPrimary,
    secondary: brandSecondary,
    surface: brandSurface,
    error: brandError,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: GoogleFonts.interTextTheme(),
    scaffoldBackgroundColor: brandSurface,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
