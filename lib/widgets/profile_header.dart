import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String location;
  final String bio;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    Key? key,
    required this.profileImageUrl,
    required this.name,
    required this.location,
    required this.bio,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(profileImageUrl),
        ),
        const SizedBox(height: 7),
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
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
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          bio,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onEditProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff2E3448),
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
