import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteModel {
  final String favouritesId;
  final String userId;
  final String postId;
  final Timestamp createdAt;

  const FavouriteModel({
    required this.favouritesId,
    required this.userId,
    required this.postId,
    required this.createdAt,
  });

  factory FavouriteModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavouriteModel(
      favouritesId: doc.id,
      userId: data['userId'] as String,
      postId: data['postId'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favouritesId': favouritesId,
      'userId': userId,
      'postId': postId,
      'createdAt': createdAt,
    };
  }

  factory FavouriteModel.fromFirestore(String id, Map<String, dynamic> data) {
    return FavouriteModel(
      favouritesId: id,
      userId: data['userId'] as String,
      postId: data['postId'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }
}
