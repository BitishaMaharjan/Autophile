import 'package:autophile/models/user_model.dart';
import 'package:autophile/widgets/home_screen/post_list_widget.dart';
import 'package:autophile/widgets/profile_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:autophile/widgets/saved_photos.dart';
import 'package:autophile/widgets/loading_skeleton.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;

  ProfileScreen(this.user, {Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showMyPosts = true;
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  Future<void> fetchPosts() async {
    final userId = await FlutterSecureStorage().read(key: 'userId');
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').where('userId',isEqualTo: userId).get();
      List<Map<String, dynamic>> fetchedPosts = snapshot.docs.map((doc) {
        return {
          'caption': doc['caption'] ?? '',
          'createdAt': doc['createdAt'] ?? '',
          'dislikes': doc['dislikes'] ?? 0,
          'image': doc['image'] ?? '',
          'likes': doc['likes'] ?? 0,
          'postId': doc.id,
          'tags': List<String>.from(doc['tags'] ?? []),
          'userId': doc['userId'] ?? 'Unknown',
          'comments': 12,
        };
      }).toList();

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

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
  void initState() {
    super.initState();
    fetchPosts();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // Data has been loaded
      });
    });
  }

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
                            widget.user?.photo?.isEmpty ?? true
                                ? 'https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png'
                                : widget.user!.photo!,
                            name: widget.user?.name?.isEmpty ?? true
                                ? 'User'
                                : widget.user!.name!,
                            location: widget.user?.address?.isEmpty ?? true
                                ? 'Earth'
                                : widget.user!.address!,
                            bio: widget.user?.bio?.isEmpty ?? true
                                ? 'Car Enthusiast'
                                : widget.user!.bio!,
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
                          isLoading
                              ? LoadingSkeleton(isPost: true, isCarSearch: true) // Show loading indicator
                              : PostListWidget(posts: posts)
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
