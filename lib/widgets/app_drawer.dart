import 'package:autophile/screens/auth/login_page.dart';
import 'package:autophile/screens/change_password.dart';
import 'package:autophile/screens/dashboard/settings_page.dart';
import 'package:autophile/screens/report_problem.dart';
import 'package:autophile/screens/terms_and%20_policies.dart';
import 'package:autophile/themes/theme_provider.dart';
import 'package:autophile/widgets/app_drawer_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();

    Future<void> logout() async {
      print('pressed');
      try {
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();

        await FirebaseAuth.instance.signOut();
        storage.delete(key: 'userId');

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Page()));

      } catch (e) {
        print("Error during logout: $e");
      }
    }
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top:30,
              left: 36,
              right: 11

            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile _picture.png'),

                ),
                const SizedBox(width: 12,),
                Column(
                  children: [
                    Text("Bitisha Maharjan",
                    style: TextStyle(
                      fontSize:15,
                        fontWeight: FontWeight.w600,

                    ),),
                    const SizedBox( height: 3,),
                    Text("bits2005@gmail.com",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                    ),)
                  ],
                )

              ],

            ),
          ),
          SizedBox(height: 40,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppDrawerTile(
                    text: 'Favourites',
                    onTap: () {
                      Navigator.pushNamed(context, '/favourite');
                    },
                    icon: Icons.bookmark,
                  ),
                  AppDrawerTile(
                    text: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                    icon: Icons.question_mark_rounded,
                  ),
                  AppDrawerTile(
                    text: 'Terms and Policies',
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=> TermsAndPoliciesScreen()));
                    },
                    icon: Icons.policy,
                  ),
                  AppDrawerTile(
                    text: 'Report a Problem',
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>ReportProblemScreen()));
                    },
                    icon: Icons.report_problem_rounded,
                  ),
                  AppDrawerTile(
                    text: 'Change Password',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePasswordScreen()));
                    },
                    icon: Icons.lock_reset_rounded,
                  ),
                  AppDrawerTile(
                    text: 'Log Out',
                    onTap: logout,
                    icon: Icons.logout,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 70,),
          // Divider
          Divider(
            color: Colors.grey.shade400,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Colour Scheme",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dark Mode",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    CupertinoSwitch(
                      value: Provider.of<ThemeProvider>(context, listen: true).isDarkMode,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
