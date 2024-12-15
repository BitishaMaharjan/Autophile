import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
            fit: BoxFit.fitWidth,
            repeat: false
        ),
      ),
    );
  }
}
