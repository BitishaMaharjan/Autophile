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


  List<Map<String, dynamic>> posts = [
    {
      'caption': 'First post caption goes here.',
      'createdAt': '2024-12-01T14:30:00Z',
      'dislikes': 2,
      'image': 'https://example.com/image1.jpg',
      'likes': 10,
      'postId': '1',
      'tags': ['Flutter', 'Development', 'Programming'],
      'userId': 'user1',
      'comments': 4,
    },
    {
      'caption': 'Second post caption, a different one.',
      'createdAt': '2024-12-02T16:15:00Z',
      'dislikes': 1,
      'image': 'https://example.com/image2.jpg',
      'likes': 15,
      'postId': '2',
      'tags': ['Tech', 'Flutter', 'Mobile'],
      'userId': 'user2',
      'comments': 4,
    },
    {
      'caption': 'Third post with some interesting content.',
      'createdAt': '2024-12-03T18:00:00Z',
      'dislikes': 0,
      'image': 'https://example.com/image3.jpg',
      'likes': 25,
      'postId': '3',
      'tags': ['Technology', 'Innovation', 'Startups', 'Flutter'],
      'userId': 'user3',
      'comments': 4,
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
