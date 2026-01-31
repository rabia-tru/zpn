import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Exact color palette (chosen to match the provided mock):
  static const Color _primaryColor = Color(0xFF7B2CBF); // deep purple
  static const Color _primaryLight = Color(0xFF9B6BFF); // lighter purple for gradient
  static const Color _scaffoldBg = Color(0xFFF6F3FC); // soft lilac background
  static const Color _surfaceColor = Color(0xFFFFFFFF); // cards / surfaces

  static final ThemeData appTheme = ThemeData(
    useMaterial3: true,
    // Start from a seeded color scheme then override specific roles to match the mock
    colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor, brightness: Brightness.light).copyWith(
      primary: _primaryColor,
      primaryContainer: _primaryLight,
      surface: _surfaceColor,
      onPrimary: Colors.white,
      onSurface: const Color(0xFF1F1B2E),
    ),
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: _scaffoldBg,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: _primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      iconTheme: IconThemeData(color: _primaryColor),
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: _surfaceColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(200, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: const Color(0xFF1F1B2E), fontWeight: FontWeight.w700),
      titleLarge: TextStyle(color: const Color(0xFF1F1B2E), fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: const Color(0xFF3C3550)),
      bodyMedium: TextStyle(color: const Color(0xFF6D6477)),
    ),
    iconTheme: IconThemeData(color: _primaryColor),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surfaceColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    brightness: Brightness.light,
  );
}
