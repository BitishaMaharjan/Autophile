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
void _onCameraTapped() {
  print("Camera tapped!");
  // Add camera logic here
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autophile',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const SplashWrapper(),
      debugShowCheckedModeBanner: false,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        onCameraTapped: _onCameraTapped,
      ),
    );
  }
}
