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
    final user = json['userId'] as Map<String, dynamic>;
    final profile = user['profile'] as Map<String, dynamic>?;

    return CommentResponse(
      id: json['id'] as String,
      nickname: user['nickname'] as String,
      profileImageUrl: profile?['profileImageUrl'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
