import 'package:flutter/material.dart';
import 'package:autophile/widgets/custom_bottom_navbar.dart';
import 'package:autophile/screens/search_page.dart';

import 'Notification.dart';


class BaseScreen extends StatefulWidget {
  final VoidCallback onCameraTapped;

  const BaseScreen({Key? key, required this.onCameraTapped}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Center(
      child:Text(
        "Home Screen",
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    ),
    Center(
      child: SearchPage(),
    ),
    Center(
      child: NotificationPage(),
    ),
    Center(
      child: Text(
        "Settings Screen",
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).colorScheme.surface, // Set the background color here
      body: SafeArea(
        // Ensures content starts below the status bar
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0), // Adds extra spacing at the top
          child: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onCameraTapped,
        backgroundColor: Colors.lightBlue,
        shape: const CircleBorder(), // Ensures the FAB is completely circular
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Keeps FAB centered
    );
  }
}
