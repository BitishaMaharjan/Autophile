import 'dart:convert';  // Import this to decode Base64 strings
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autophile/widgets/loading_skeleton.dart';
import 'package:autophile/widgets/profile_header.dart';
import 'package:autophile/models/user_model.dart';
import 'package:autophile/widgets/home_screen/post_list_widget.dart';
import 'dart:async';

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

  StreamSubscription<QuerySnapshot>? _photosSubscription;
  List<Map<String, dynamic>> savedPhotos = [];


  // Function to decode base64 image and return as an Image
  Image decodeBase64Image(String base64String) {
    final bytes = base64Decode(base64String);
    return Image.memory(bytes, fit: BoxFit.cover);
  }

  Future<void> fetchPosts() async {
    final userId = await FlutterSecureStorage().read(key: 'userId');
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').where('userId', isEqualTo: userId).get();
      List<Map<String, dynamic>> fetchedPosts = snapshot.docs.map((doc) {
        return {
          'caption': doc['caption'] ?? '',
          'createdAt': doc['createdAt'] ?? '',
          'downvote': doc['downvote'] ?? 0,
          'image': doc['image'] ?? '',
          'upvote': doc['upvote'] ?? 0,
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

  void fetchPhotos() async {
    final userId = await FlutterSecureStorage().read(key: 'userId');
    if (userId == null) return;

    _photosSubscription = FirebaseFirestore.instance
        .collection('classified_images')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> fetchedPhotos = snapshot.docs.map((doc) {
        return {
          'docId': doc.id,
          'label': doc['label'] ?? '',
          'confidence': doc['confidence'] ?? '',
          'image': doc['image'] ?? '',
        };
      }).toList();

      setState(() {
        savedPhotos = fetchedPhotos;
        isLoading = false; // Stop showing the loading skeleton
      });
    }, onError: (error) {
      print('Error listening to photos: $error');
    });
  }
  Future<void> deletePhoto(String docId) async {
    try {
      // Delete the document from Firestore
      await FirebaseFirestore.instance
          .collection('classified_images')
          .doc(docId)
          .delete();

      // Update the local state to remove the deleted photo
      setState(() {
        savedPhotos.removeWhere((photo) => photo['docId'] == docId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo deleted successfully!')),
      );
    } catch (error) {
      print('Error deleting photo: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete photo.')),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    fetchPosts();
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                                ? ''
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
                          const SizedBox(height: 13),
                          Divider(
                            color: Colors.grey.shade400,
                            thickness: 1,
                          ),
                          const SizedBox(height: 14),
                          isLoading
                              ? LoadingSkeleton(isPost: true, isCarSearch: true)
                              : showMyPosts
                              ? PostListWidget(posts: posts)
                              : savedPhotos.isEmpty
                              ? Center(child: Text('No saved photos available'))
                              : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: savedPhotos.length,
                            itemBuilder: (context, index) {
                              final photo = savedPhotos[index];
                              final base64Image = photo['image'] ?? '';
                              final decodedImage = decodeBase64Image(base64Image);

                              return SizedBox(
                                width: 250, // Adjust the width here
                                height: 250, // Adjust the height here
                                child: Card(
                                  elevation: 4,
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Flexible(child: decodedImage), // Ensure image scales properly
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              photo['label'] ?? 'No Label',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis, // Prevent text overflow
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              'Confidence: ${photo['confidence'] ?? 'N/A'}',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        bottom: 25,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () async {
                                            await deletePhoto(photo['docId']); // Pass the document ID
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )



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
