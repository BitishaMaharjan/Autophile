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
        children: [
          Padding(
            padding: const EdgeInsets.only(top:100),
            child: Icon(Icons.lock_open_rounded,size: 80,color: Theme.of(context).colorScheme.inversePrimary,),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(),
          ),
          AppDrawerTile(text: 'H O M E', onTap: (){
            Navigator.pop(context);
          }, icon: Icons.home),
          AppDrawerTile(text: 'S E T T I N G S', onTap: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SettingsPage()));
          }, icon: Icons.settings),
          const Spacer(),
          AppDrawerTile(text: 'L O G O U T', onTap: (){}, icon: Icons.logout),
          const SizedBox(height: 25,)
        ],
      ),
    );
  }
}
