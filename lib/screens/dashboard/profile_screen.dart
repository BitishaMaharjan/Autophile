import 'package:autophile/models/user_model.dart';
import 'package:autophile/widgets/home_screen/post_list_widget.dart';
import 'package:autophile/widgets/profile_header.dart';
import 'package:flutter/material.dart';

import 'package:autophile/widgets/app_drawer.dart';
import 'package:autophile/widgets/saved_photos.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;

  ProfileScreen(this.user, {Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showMyPosts = true;

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

  final List<Map<String, String>> savedPhotos = [
    {
      'image': 'assets/images/savedcar1.png',
      'name': 'Volkswagen Polo',
    },
    {
      'image': 'assets/images/savedcar2.png',
      'name': 'Tesla Model X',
    },
    {
      'image': 'assets/images/savedcar3.png',
      'name': 'Mercedes G-Wagon',
    },
    {
      'image': 'assets/images/savedcar1.png',
      'name': 'BMW X5',
    },
    {
      'image': 'assets/images/savedcar2.png',
      'name': 'BMW X5',
    },
    {
      'image': 'assets/images/savedcar3.png',
      'name': 'BMW X5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // endDrawer: const AppDrawer(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          ProfileHeader(
                            profileImageUrl:
                            widget.user?.photo?.isEmpty ?? true ? 'https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png'
                                : widget.user!.photo!,
                            name:
                            widget.user?.name?.isEmpty ?? true ? 'User' : widget.user!.name!,
                            location:
                            widget.user?.address?.isEmpty ?? true ? 'Earth' : widget.user!.address!,
                            bio:
                            widget.user?.bio?.isEmpty ?? true ? 'Car Enthusiast' : widget.user!.bio!,
                            onEditProfile: () {},
                          ),
                          const SizedBox(height: 26),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showMyPosts = true;
                                  });
                                },
                                child: Text(
                                  "My Posts",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: showMyPosts
                                        ? Theme.of(context).colorScheme.secondary
                                        : Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showMyPosts = false;
                                  });
                                },
                                child: Text(
                                  "Saved Photos",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: !showMyPosts
                                        ? Theme.of(context).colorScheme.secondary
                                        : Theme.of(context).colorScheme.onPrimary,
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
                          const SizedBox(height: 14),
                          showMyPosts
                              ? PostListWidget(posts: posts) // My Posts
                              : SavedPhotosWidget(savedPhotos: savedPhotos),
                        ],
                      ),
                      Positioned(
                        top: 11,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: const Icon(
                            Icons.settings,
                            size: 34,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
