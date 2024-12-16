
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoadingComponent extends StatelessWidget {
  final String animationPath;
  final String? message;
  final double? animationWidth;
  final double? animationHeight; // Height of the animation

  const LottieLoadingComponent({
    Key? key,
    required this.animationPath,
    this.message,
    this.animationWidth,
    this.animationHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animationPath,
            width: animationWidth ?? 180, // Default size
            height: animationHeight ?? 180,
            fit: BoxFit.contain,
          ),
          if (message != null) ...[
            const SizedBox(height: 16), // Spacing
            Text(
              message!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}
