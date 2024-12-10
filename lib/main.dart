import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';  // Import Firebase Realtime Database
import 'package:autophile/screens/camera_scan/camera_page.dart';
import 'package:autophile/screens/onboarding/landing_page.dart';
import 'package:autophile/screens/Dashboard/base_screen.dart';
import 'package:autophile/screens/auth/login_page.dart';
import 'package:autophile/screens/onboarding/SplashWrapper.dart';
import 'package:autophile/themes/theme_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final databaseReference = FirebaseDatabase.instance.ref();
  print("Firebase Realtime Database URL: ${databaseReference}");
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Autophile',
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashWrapper(),
            '/auth': (context) => const Login_Page(),
            '/home': (context) => BaseScreen(),
            '/landing': (context) => LandingPage(),
            '/camera': (context) => CameraPage(),
          },
        );
      },
    );
  }
}