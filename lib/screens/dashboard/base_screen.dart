import 'package:autophile/screens/dashboard/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:autophile/widgets/custom_bottom_navbar.dart';
import 'package:autophile/screens/dashboard/home_screen.dart';
import 'package:autophile/screens/dashboard/search_page.dart';
import 'package:autophile/screens/dashboard/Notification.dart';
import 'package:autophile/screens/dashboard/profile_screen.dart';


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
      child: HomeScreen(),
    ),
    Center(
      child: SearchPage(),
    ),
    Center(
      child: NotificationPage(),
    ),
    Center(
      child: ProfileScreen(),
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
        onPressed: (){ Navigator.pushNamed(context, '/camera');},
        backgroundColor: Colors.lightBlue,
        shape: const CircleBorder(),
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Keeps FAB centered
    );
  }
}
