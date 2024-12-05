import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const AppButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child:Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color:Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8)
          ),
          child: Center(child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16
            ),
          )),
        )
    );
  }
}
