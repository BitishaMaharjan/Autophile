import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? postId;
  final String caption;
  final List<String> tags;
  final String image;
  final String userId;
  final DateTime createdAt;
  final int upvote;
  final int downvote;

  const PostModel({
    this.postId,
    required this.caption,
    required this.tags,
    required this.image,
    required this.userId,
    required this.createdAt,
    this.upvote = 0,
    this.downvote = 0,
  });

  factory PostModel.fromSnapshot(String postId, Map<String, dynamic> data) {
    return PostModel(
      postId: postId,
      caption: data['caption'] as String,
      tags: List<String>.from(data['tags'] ?? []),
      image: data['image'] as String,
      userId: data['userId'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
      upvote: data['upvote'] ?? 0,
      downvote: data['downvote'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'tags': tags,
      'image': image,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'upvote': upvote,
      'downvote': downvote,
    };
  }

  Future<void> increaseUpvoteCount(String postId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.update({
      'upvote': FieldValue.increment(1),
    });
  }

  Future<void> increaseDownvoteCount(String postId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.update({
      'downvote': FieldValue.increment(1),
    });
  }

  Future<void> decreaseUpvoteCount(String postId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.update({
      'upvote': FieldValue.increment(-1),
    });
  }

  Future<void> decreaseDownvoteCount(String postId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.update({
      'downvote': FieldValue.increment(-1),
    });
  }
}
