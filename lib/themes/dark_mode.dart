import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.dark(
      surface: const Color.fromARGB(255, 20, 20, 20),
      primary: Colors.black,
      secondary: const Color(0xFF4D4D4D),
      onPrimary: const Color(0xFFE0E0E0),
      onSecondary: const Color(0xFFBDBDBD),
      onTertiary: const Color(0xFF757575),
      inversePrimary: Colors.white,
    )
);