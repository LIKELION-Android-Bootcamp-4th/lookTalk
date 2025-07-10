class CommentResponse {
  final String id;
  final String nickname;
  final String? profileImageUrl;
  final String content;
  final DateTime createdAt;

  CommentResponse({
    required this.id,
    required this.nickname,
    required this.profileImageUrl,
    required this.content,
    required this.createdAt,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
