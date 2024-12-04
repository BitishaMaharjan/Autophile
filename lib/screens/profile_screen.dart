import 'package:autophile/widgets/home_screen/post_list_widget.dart';
import 'package:autophile/widgets/profile_header.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showMyPosts=true;
  final List<Map<String, String>> posts = [
    {
      'user': 'Car Guy',
      'location': 'Monaco, India',
      'content': 'How much will this cost on average?',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSO1q5iuu6wJJpVVV5U4Gr_SvpPwdiiYzXGcg&s',
      'likes': '110',
      'comments': '3',
      'shares': '45',
    },
    {
      'user': 'Tech Enthusiast',
      'location': 'Silicon Valley, USA',
      'content': 'What is the latest trend in AI technology?',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcUoJOCMikZl8T5BA16Uqfl-GGcxemCvfbCw&s',
      'likes': '150',
      'comments': '5',
      'shares': '60',
    },
  ];
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
                    right: 20,
                    left: 20,

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
                      showMyPosts
                          ? PostListWidget(posts:posts) // My Posts
                          : Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Saved Photos will appear here",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
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
