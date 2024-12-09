class CarNews {
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String content;
  final String publishedAt;
  final String url;

  CarNews({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.content,
    required this.publishedAt,
    required this.url,
  });

  factory CarNews.fromMap(Map<String, dynamic> data) {
    return CarNews(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      author: data['author'] ?? '',
      content: data['content'] ?? '',
      publishedAt: data['publishedAt'] ?? '',
      url: data['url'] ?? '',
    );
  }

  /// Convert a CarNews object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'author': author,
      'content': content,
      'publishedAt': publishedAt,
      'url': url,
    };
  }
}
