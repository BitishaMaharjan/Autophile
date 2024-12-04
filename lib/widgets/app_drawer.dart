import 'package:autophile/screens/dashboard/settings_page.dart';
import 'package:autophile/widgets/app_drawer_tile.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top:92,
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
          SizedBox(height: 80,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center all tiles
              children: [
                AppDrawerTile(
                  text: 'Language',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.language,
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
                    Navigator.pop(context);
                  },
                  icon: Icons.policy,
                ),
                AppDrawerTile(
                  text: 'Report a Problem',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.report_problem_rounded,
                ),
                AppDrawerTile(
                  text: 'Change Password',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.lock_reset_rounded,
                ),
                AppDrawerTile(
                  text: 'Log Out',
                  onTap: () {},
                  icon: Icons.logout,
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
