import 'package:autophile/screens/SplashWrapper.dart';
import 'package:autophile/screens/landing_page.dart';
import 'package:autophile/screens/reset_password.dart';
import 'package:autophile/screens/settings_page.dart';
import 'package:autophile/themes/theme_provider.dart';
import 'package:autophile/screens/base_screen.dart';
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
  const MyApp({Key? key}) : super(key: key);

  void _onCameraTapped() {
    print('Camera tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Autophile',
          theme: themeProvider.themeData,
          home: const LandingPage(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/home',
          routes: {
            '/home': (context) => BaseScreen(onCameraTapped: _onCameraTapped),
            '/landing': (context) => LandingPage(),

          },
        );
      },
    );
  }
}
