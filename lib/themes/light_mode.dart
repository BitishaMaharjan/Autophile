import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
      surface: Color(0xFFF5F5F5),
      primary: Colors.white,
      secondary: Color(0xFF2E3448),
      onPrimary: Color(0xFF757575),
      onSecondary: Color(0xFF4D4D4D),
      onTertiary: Color(0xFF1A2D5D),
      inversePrimary: Color(0xFF0F1419),
      ),
      textTheme: TextTheme(
            bodyMedium: GoogleFonts.poppins()
      )
);