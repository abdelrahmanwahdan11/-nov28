import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData buildLight(Color primary) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        background: const Color(0xFFD9F7C4),
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFD9F7C4),
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme),
      cardColor: Colors.white,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        selectedItemColor: primary,
        unselectedItemColor: const Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: primary.withOpacity(.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        labelStyle: GoogleFonts.nunito(color: const Color(0xFF111827)),
      ),
    );
  }

  static ThemeData buildDark(Color primary) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primary,
        background: const Color(0xFF020617),
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF020617),
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).apply(bodyColor: Colors.white),
      cardColor: const Color(0xFF111827),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        selectedItemColor: primary,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFF111827),
        selectedColor: primary.withOpacity(.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        labelStyle: GoogleFonts.nunito(color: Colors.white),
      ),
    );
  }
}
