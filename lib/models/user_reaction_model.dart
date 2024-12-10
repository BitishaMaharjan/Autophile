class UserReactionModel {
  final String userId;
  final String postId;
  final bool isLike;

  UserReactionModel({
    required this.userId,
    required this.postId,
    required this.isLike,
  });

  factory UserReactionModel.fromJson(Map<String, dynamic> data) {
    return UserReactionModel(
      userId: data['userId'] as String,
      postId: data['postId'] as String,
      isLike: data['isLike'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': postId,
      'isLike': isLike,
    };
  }
}
