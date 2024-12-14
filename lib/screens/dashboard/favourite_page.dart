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
      } else {
        setState(() {
          posts = [];
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching posts: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Favourites',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        shadowColor: Colors.black12,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: isLoading
            ? Center(
          child: LoadingSkeleton(isPost: true, isCarSearch: true),
        )
            : posts.isEmpty
            ? _buildEmptyState()
            : _buildPostList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'No Favourites Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add posts to your favourites and they will appear here.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList() {
    return Expanded(
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostListWidget(posts: posts);
        },
      ),
    );
  }
}
