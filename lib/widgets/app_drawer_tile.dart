import 'package:flutter/material.dart';

class AppDrawerTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const AppDrawerTile({super.key,required this.text, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:25.0),
      child: ListTile(
        title: Text(text,style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,

        ),
        ),
        leading: Icon(icon,color: Theme.of(context).colorScheme.inversePrimary,),
        onTap: onTap,
      ),
    );
  }
}
