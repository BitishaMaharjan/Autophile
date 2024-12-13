import 'package:autophile/widgets/home_screen/post_list_widget.dart';
import 'package:autophile/widgets/loading_skeleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavouritePage extends StatefulWidget {


  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<Map<String, dynamic>> posts = [];

  bool isLoading = true;

  Future<void> fetchPosts() async {
    final userId = await FlutterSecureStorage().read(key: 'userId');
    try {
      QuerySnapshot favoritesSnapshot = await FirebaseFirestore.instance
          .collection('favourites')
          .where('userId', isEqualTo: userId)
          .get();

      List<String> postIds = favoritesSnapshot.docs.map((doc) {
        return doc['postId'] as String;
      }).toList();

      if (postIds.isNotEmpty) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where(FieldPath.documentId, whereIn: postIds)
            .get();

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
      } else {
        setState(() {
          posts = [];
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }




  @override
  void initState() {
    super.initState();
    fetchPosts();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Your Favourite',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Favourite',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 16),
            if (posts.isEmpty)
              Center(
                child: Text(
                  'No favorite posts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              )
            else
              isLoading
                  ? LoadingSkeleton(isPost: true, isCarSearch: true) // Show loading indicator
                  : PostListWidget(posts: posts)
          ],
        ),
      ),
    );
  }
}
