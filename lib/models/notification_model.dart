import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? notificationId;
  final String userId;
  final String postOwnerId;
  final String postId;
  final String type;
  final Timestamp createdAt;
  final bool isRead;

  const NotificationModel({
    this.notificationId,
    required this.userId,
    required this.postOwnerId,
    required this.postId,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromSnapshot(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] as String?,
      userId: json['userId'] as String,
      postOwnerId: json['postOwnerId'] as String,
      postId: json['postId'] as String,
      type: json['type'] as String,
      createdAt: json['createdAt'] as Timestamp,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postOwnerId': postOwnerId,
      'postId': postId,
      'type': type,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromFirestore(String id, Map<String, dynamic> data) {
    return NotificationModel(
      notificationId: id,
      userId: data['userId'] ?? '',
      postOwnerId: data['postOwnerId'] ?? '',
      postId: data['postId'] ?? '',
      type: data['type'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      isRead: data['isRead'] ?? false,
    );
  }
}
