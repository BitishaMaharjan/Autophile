import 'package:flutter/material.dart';

class HomeFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HomeFloatingButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Color(0xFF2E3448),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
