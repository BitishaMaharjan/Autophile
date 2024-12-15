import 'dart:convert';

import 'package:autophile/screens/edit_profile.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String location;
  final String bio;

  const ProfileHeader({
    Key? key,
    required this.profileImageUrl,
    required this.name,
    required this.location,
    required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30,),
        CircleAvatar(
          radius: 60,
          backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
              ? MemoryImage(base64Decode(profileImageUrl))
              : NetworkImage('https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png')
        ),
        const SizedBox(height: 7),
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on,
              size: 18,
              color: Colors.grey,
            ),
            const SizedBox(width: 4.75),
            Text(
              location,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          bio,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        ElevatedButton(
          onPressed:(){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          child: const Text(
            "Edit Profile",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
