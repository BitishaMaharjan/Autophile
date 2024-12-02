import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
    final screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      body:SafeArea(
          child:Container(
            color: Theme.of(context).colorScheme.surface,
            child: SingleChildScrollView(
              child: Padding(padding: EdgeInsets.symmetric(
                
              )),
            ),
          ) ,)

    );
  }
}
