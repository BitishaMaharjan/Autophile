import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeaturedPostsList extends StatefulWidget {
  const FeaturedPostsList({Key? key}) : super(key: key);

  @override
  State<FeaturedPostsList> createState() => _FeaturedPostsListState();
}

class _FeaturedPostsListState extends State<FeaturedPostsList> {
  List<Map<String, dynamic>> mostUpvotedPosts = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchTopPosts();
  }

  Future<void> fetchTopPosts() async {
    try {
      final firestore = FirebaseFirestore.instance;
      print('Fetching posts from Firestore...');

      final QuerySnapshot postSnapshot = await firestore
          .collection('posts')
          .orderBy('upvote', descending: true)
          .limit(10)
          .get();

      print('Found ${postSnapshot.docs.length} posts');

      List<Map<String, dynamic>> posts = [];

      for (var doc in postSnapshot.docs) {
        try {
          final postData = doc.data() as Map<String, dynamic>;
          print('Processing post: ${doc.id}');

          if (postData['userId'] == null) {
            print('Warning: userId is null for post ${doc.id}');
            continue;
          }

          final userDoc = await firestore
              .collection('users')
              .doc(postData['userId'])
              .get();

          if (!userDoc.exists) {
            print('Warning: User document not found for userId: ${postData['userId']}');
            continue;
          }

          final userData = userDoc.data() as Map<String, dynamic>;

          if (postData['image'] == null) {
            print('Warning: image is null for post ${doc.id}');
            continue;
          }

          Uint8List imageBytes;
          try {
            imageBytes = base64Decode(postData['image']);  // This now correctly returns Uint8List
          } catch (e) {
            print('Error decoding image for post ${doc.id}: $e');
            continue;
          }

          posts.add({
            'id': doc.id,
            'photoBytes': imageBytes,  // This is now the correct type
            'upvote': postData['upvote'] ?? 0,
            'name': userData['name'] ?? 'Unknown User',
            'userId': postData['userId'],
          });

          print('Successfully added post ${doc.id} to list');
        } catch (e) {
          print('Error processing post document: $e');
        }
      }

      if (mounted) {
        setState(() {
          mostUpvotedPosts = posts;
          isLoading = false;
          error = null;
        });
      }
    } catch (error) {
      print('Error fetching posts: $error');
      if (mounted) {
        setState(() {
          this.error = error.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: fetchTopPosts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (mostUpvotedPosts.isEmpty) {
      return const Center(
        child: Text('No posts found'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: mostUpvotedPosts.map((post) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.memory(
                    post['photoBytes'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${post['upvote']} upvote',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}