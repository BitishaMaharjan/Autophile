class CommentModel {
  final String commentId;
  final String postId;
  final String userId;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromSnapshot(String commentId, Map<String, dynamic> data) {
    return CommentModel(
      commentId: commentId,
      postId: data['postId'] as String,
      userId: data['userId'] as String,
      text: data['text'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
