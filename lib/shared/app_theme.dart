import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _accentOrange = Color(0xFFFF6B2C);
  static const _deepPurple = Color(0xFF6C63FF);
  static const _darkBackground = Color(0xFF0F172A);

  static ThemeData get lightTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _accentOrange,
      brightness: Brightness.light,
    );
    final colorScheme = baseScheme.copyWith(
      secondary: _deepPurple,
      surface: const Color(0xFFF5F6FB),
    );
    const scaffoldColor = Color(0xFFF3F4FA);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldColor,
      textTheme: _buildTextTheme(Brightness.light),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        prefixIconColor: colorScheme.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: GoogleFonts.bebasNeue(
          fontSize: 24,
          letterSpacing: 1,
          color: colorScheme.onSurface,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondary.withValues(alpha: 0.1),
        side: BorderSide(color: colorScheme.secondary.withValues(alpha: 0.3)),
        labelStyle: GoogleFonts.montserrat(
          color: colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _accentOrange,
      brightness: Brightness.dark,
    );
    final colorScheme = baseScheme.copyWith(
      secondary: _deepPurple,
      surface: const Color(0xFF151B2D),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkBackground,
      textTheme: _buildTextTheme(Brightness.dark),
      cardTheme: CardThemeData(
        color: const Color(0xFF1F2539),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1F2539),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        prefixIconColor: colorScheme.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: GoogleFonts.bebasNeue(
          fontSize: 24,
          letterSpacing: 1,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondary.withValues(alpha: 0.2),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        labelStyle: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final base = GoogleFonts.montserratTextTheme();
    final headlineColor = brightness == Brightness.dark ? Colors.white : Colors.black87;

    return base.copyWith(
      displayLarge: GoogleFonts.bebasNeue(
        fontSize: 64,
        letterSpacing: 2,
        color: headlineColor,
      ),
      displayMedium: GoogleFonts.bebasNeue(
        fontSize: 48,
        letterSpacing: 2,
        color: headlineColor,
      ),
      headlineLarge: GoogleFonts.bebasNeue(
        fontSize: 34,
        letterSpacing: 1.4,
        color: headlineColor,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: headlineColor,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: headlineColor,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: headlineColor,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        color: brightness == Brightness.dark ? Colors.white70 : Colors.black87,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        color: brightness == Brightness.dark ? Colors.white60 : Colors.black54,
      ),
      labelLarge: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.montserrat(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
