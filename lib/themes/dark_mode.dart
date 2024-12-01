import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.dark(
      surface: const Color.fromARGB(255, 20, 20, 20),
      primary: const Color.fromARGB(255, 122, 122, 122),
      secondary: const Color.fromARGB(255, 30, 30, 30),
      tertiary: const Color.fromARGB(255, 47, 47, 47),
      inversePrimary: Colors.grey[300],
    ),
    textTheme: TextTheme(
        bodyMedium: GoogleFonts.poppins()
    )
);