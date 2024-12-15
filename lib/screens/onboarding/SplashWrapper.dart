import 'package:autophile/screens/Dashboard/base_screen.dart';
import 'package:autophile/screens/onboarding/landing_page.dart';
import 'package:autophile/screens/dashboard/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkUserId();
  }


  void _checkUserId() async {
    await Future.delayed(const Duration(seconds: 4));

    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LandingPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Lottie.asset(
          'assets/animation/autophile_animation.json',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
          repeat: false,
        ),
      ),
    );
  }
}