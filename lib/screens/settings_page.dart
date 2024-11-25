import 'package:autophile/themes/theme_provider.dart';
import 'package:autophile/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
            margin: const EdgeInsets.only(left: 25,top: 10,right: 25),
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dark Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),),
                CupertinoSwitch(value: Provider.of<ThemeProvider>(context,listen: false).isDarkMode, onChanged: (value){
                  Provider.of<ThemeProvider>(context,listen: false).toggleTheme();
                })
              ],
            ),
          ),
          SizedBox(height: 30,),
          AppButton(text: 'test', onTap: (){}),
          SizedBox(height: 30,),
          AppButton(text: 'Next', onTap: (){})
        ],
      ),
    );
  }
}

