import 'package:flutter/material.dart';

class HomeFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HomeFloatingButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
