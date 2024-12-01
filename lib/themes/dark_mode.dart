import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
   colorScheme: ColorScheme.dark(
        surface: Color(0xFF121212),
        primary: Color(0xFF1F1F1F),
        secondary: Color(0xFF2E3448),
        onPrimary: Color(0xFFE0E0E0),
        onSecondary: Color(0xFFB0BEC5),
        onTertiary: Color(0xFF90CAF9),
        inversePrimary: Color(0xFFFFFFFF)
    ),
    textTheme: TextTheme(
        bodyMedium: GoogleFonts.poppins()
    )
);