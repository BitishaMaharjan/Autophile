import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
   colorScheme: ColorScheme.dark(
        surface: Color(0xFF000000),
        primary: Color(0xFF1F1F1F),
        secondary: Color(0xFFFFD67D),
        onPrimary: Color(0xFFC1C1C1),
        onSecondary: Color(0xFFE4EFF4),
        onTertiary: Color(0xFF90CAF9),
        inversePrimary: Color(0xFFFFFFFF)
    ),
    textTheme: TextTheme(
        bodyLarge: GoogleFonts.poppins(
            color: Colors.white,
        ),
        bodyMedium: GoogleFonts.poppins(
            color: Colors.white,
        ),
        titleMedium: GoogleFonts.poppins(
            color: Colors.white,
        ),
    )
);