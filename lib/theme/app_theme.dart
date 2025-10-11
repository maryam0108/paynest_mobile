import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF14B8A6), // teal-500
      surface: Color(0xFF0B2533),
    ),
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
  );
}

const kGradient = LinearGradient(
  colors: [Color(0xFF0F766E), Color(0xFF115E59), Color(0xFF0A1A2F)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);