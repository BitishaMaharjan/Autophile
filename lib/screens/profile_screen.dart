import 'package:autophile/widgets/profile_header.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showMyPosts=true;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top:21,
                    right: 74,
                    left: 74

                  ),
                  child: Column(
                    children: [
                      ProfileHeader(
                        profileImageUrl: "assets/images/profile _picture.png",
                        name: "Bitisha Maharjan",
                        location: "Kathmandu, Nepal",
                        bio: "Car enthusiast / heritage lover",
                        onEditProfile: () {},
                      ),
                      const SizedBox(height: 26,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                showMyPosts=true;
                              });
                            },
                            child: Text(
                              "My Posts",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: showMyPosts ?Theme.of(context).colorScheme.secondary
                                :Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                showMyPosts=false;
                              });
                            },
                            child: Text(
                              "Saved Photos",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.secondary,
                              ),

                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13), // Gap below the section
                      Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                      const SizedBox(height: 14,),

                    ],
                  ),
                ),
              ),

              // Settings Icon Positioned
              Positioned(
                top: screenHeight * 0.03,
                right: screenWidth * 0.05,
                child: GestureDetector(
                  onTap: () {
                  },
                  child: const Icon(
                    Icons.settings,
                    size: 32,

                  ),
                ),
              ),


            ],

          ),
        ),
      ),
    );
  }
}
