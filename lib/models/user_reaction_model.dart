
class UserReaction {
  final String? id;
  final String postId;
  final String userId;
  final bool upvote;
  final bool downvote;

  const UserReaction({
    this.id,
    required this.postId,
    required this.userId,
    this.upvote = false,
    this.downvote = false,
  });

  factory UserReaction.fromSnapshot(Map<String, dynamic> json) {
    return UserReaction(
      id: json['id'] as String?,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      upvote: json['upvote'] as bool? ?? false,
      downvote: json['downvote'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'upvote': upvote,
      'downvote': downvote,
    };
  }

  factory UserReaction.fromFirestore(String id, Map<String, dynamic> data) {
    return UserReaction(
      id: id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      upvote: data['upvote'] ?? false,
      downvote: data['downvote'] ?? false,
    );
  }
}
