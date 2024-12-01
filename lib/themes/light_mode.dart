import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
      surface: Color(0xFFF5F5F5),
      primary: Color(0xFF2E3448),
      secondary: Colors.black.withOpacity(0.2),
      tertiary: Colors.white,
      inversePrimary: Color(0xFF0F1419),
      ),
      textTheme: TextTheme(
            bodyMedium: GoogleFonts.poppins()
      )
);