import 'package:autophile/models/user_model.dart';
import 'package:autophile/screens/dashboard/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autophile/widgets/custom_bottom_navbar.dart';
import 'package:autophile/screens/dashboard/home_screen.dart';
import 'package:autophile/screens/dashboard/search_page.dart';
import 'package:autophile/screens/dashboard/Notification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class BaseScreen extends StatefulWidget {

  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {

  int _selectedIndex = 0;
  final storage = FlutterSecureStorage();
  UserModel? currentUser;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  Future<void> fetchUserData()async{
    try{
      String? userId = await storage.read(key: 'userId');
      if(userId == null){
        Navigator.pushNamed(context, '/auth');
        return;
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if(userDoc.exists){
        setState(() {
        currentUser = UserModel.fromFirestore(
            userDoc.id, userDoc.data() as Map<String, dynamic>);
      });
      }
    }catch(e){
      print(e);
    }

  }

  List<Widget> _getScreens() {
    return [
      Center(
        child: HomeScreen(currentUser),
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
          style: TextStyle(fontSize: 24),
        ),
      ),
    ];
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: currentUser == null
      ? Center(child: CircularProgressIndicator())
          : Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: IndexedStack(
            index: _selectedIndex,
            children: _getScreens(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
