class PostResponse {
  final String id;
  final String title;
  final String content;
  final String category;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;

  PostResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'],
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
