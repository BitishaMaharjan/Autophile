import 'package:autophile/screens/camera_scan/camera_page.dart';
import 'package:autophile/screens/onboarding/landing_page.dart';
import 'package:autophile/screens/Dashboard/base_screen.dart';
import 'package:autophile/screens/auth/login_page.dart'; // Import LoginPage
import 'package:autophile/screens/onboarding/SplashWrapper.dart'; // Import SplashScreen
import 'package:autophile/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
  const MyApp({super.key});
  void _onCameraTapped() {
    print('Camera tapped');
  }

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
            '/': (context) => const SplashWrapper(), // Splash screen route
            '/auth': (context) => const Login_Page(),   // Login screen route
            '/home': (context) => BaseScreen(), // Base screen route
            '/landing': (context) => LandingPage(),
            '/camera': (context) => CameraPage(),
          },
        );
      },
    );
  }
}