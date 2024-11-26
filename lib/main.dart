import 'package:flutter/material.dart';
import 'package:autophile/screens/MainScreen.dart';
import 'package:autophile/themes/theme_provider.dart';
import 'package:autophile/screens/login_page.dart';
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
          home: const Login_Page(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/home',
          routes: {
            '/home': (context) => BaseScreen(onCameraTapped: _onCameraTapped),
          },
        );
      },
    );
  }
}
