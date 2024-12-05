import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onMicPressed;

  const SearchBarWidget({required this.onMicPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(40),
      child: TextField(
        cursorColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
        decoration: InputDecoration(
          hintText: "Search Car",
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: IconButton(
            icon: Icon(Icons.mic, color: Colors.grey),
            onPressed: onMicPressed,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
