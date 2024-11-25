import 'package:autophile/screens/SplashWrapper.dart';
import 'package:autophile/screens/landing_page.dart';
import 'package:autophile/screens/settings_page.dart';
import 'package:autophile/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
      runApp(
      ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
  child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autophile',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const SplashWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
