import 'package:autophile/screens/dashboard/favourite_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:autophile/screens/camera_scan/camera_page.dart';
import 'package:autophile/screens/onboarding/landing_page.dart';
import 'package:autophile/screens/Dashboard/base_screen.dart';
import 'package:autophile/screens/auth/login_page.dart';
import 'package:autophile/screens/onboarding/SplashWrapper.dart';
import 'package:autophile/themes/theme_provider.dart';
import 'firebase_options.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Database Debug Print
  final databaseReference = FirebaseDatabase.instance.ref();
  print("Firebase Realtime Database Root Reference: ${databaseReference.path}");

  // Load Theme Preferences
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  // Fetch Camera List
  final cameras = await availableCameras();

  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: MyApp(cameras: cameras),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.cameras});

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
            '/camera': (context) => CameraScreen(cameras: cameras),
            '/favourite': (context) => FavouritePage(),
          },
        );
      },
    );
  }
}
