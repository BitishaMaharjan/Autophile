// import 'package:autophile/screens/camera_scan/camera_page.dart';
// import 'package:autophile/screens/onboarding/landing_page.dart';
// import 'package:flutter/material.dart';
// import 'package:autophile/screens/Dashboard/base_screen.dart';
// import 'package:autophile/themes/theme_provider.dart';
// import 'package:provider/provider.dart';
//
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   void _onCameraTapped() {
//     print('Camera tapped');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           title: 'Autophile',
//           theme: themeProvider.themeData,
//           home: const CameraPage(),
//           debugShowCheckedModeBanner: false,
//           initialRoute: '/home',
//           routes: {
//             '/home': (context) => BaseScreen(onCameraTapped: _onCameraTapped),
//             '/landing': (context) => LandingPage(),
//           },
//
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:autophile/screens/camera_scan/camera_page.dart';
import 'package:autophile/screens/onboarding/landing_page.dart';
import 'package:autophile/screens/Dashboard/base_screen.dart';
import 'package:autophile/screens/auth/login_page.dart'; // Import LoginPage
import 'package:autophile/screens/onboarding/SplashWrapper.dart'; // Import SplashScreen
import 'package:autophile/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashWrapper(), // Splash screen route
            '/login': (context) => const Login_Page(),   // Login screen route
            '/home': (context) => BaseScreen(onCameraTapped: _onCameraTapped), // Base screen route
            '/landing': (context) => LandingPage(),
            '/camera': (context) => CameraPage(),

          },
        );
      },
    );
  }
}
