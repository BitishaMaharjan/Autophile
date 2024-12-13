import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? postId;
  final String caption;
  final List<String> tags;
  final String image;
  final String userId;
  final DateTime createdAt;
  final int likes;
  final int dislikes;

  const PostModel({
    this.postId,
    required this.caption,
    required this.tags,
    required this.image,
    required this.userId,
    required this.createdAt,
    this.likes = 0,
    this.dislikes = 0,
  });

  factory PostModel.fromSnapshot(String postId, Map<String, dynamic> data) {
    return PostModel(
      postId: postId,
      caption: data['caption'] as String,
      tags: List<String>.from(data['tags'] ?? []),
      image: data['image'] as String,
      userId: data['userId'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
      likes: data['likes'] ?? 0,
      dislikes: data['dislikes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'tags': tags,
      'image': image,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  // Method to update likes count
  Future<void> updateLikesCount(int change, String postId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.update({
      'likes': FieldValue.increment(change),
    });
  }

  // Method to update dislikes count
  Future<void> updateDislikesCount(int change, String postId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.update({
      'dislikes': FieldValue.increment(change),
    });
  }
}
