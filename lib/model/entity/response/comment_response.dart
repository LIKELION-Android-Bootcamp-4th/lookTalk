class CommentResponse {
  final String id;
  final String userId;
  final String nickname;
  final String? profileImageUrl;
  final String content;
  final DateTime createdAt;

  CommentResponse({
    required this.id,
    required this.userId,
    required this.nickname,
    required this.profileImageUrl,
    required this.content,
    required this.createdAt,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    final user = json['userId'] as Map<String, dynamic>?;
    final profile = user?['profile'] as Map<String, dynamic>?;

    return CommentResponse(
      id: json['id'] as String,
      userId: user?['id'] ?? '',
      nickname: user?['nickName'] ?? '알 수 없음',
      profileImageUrl: profile?['profileImage'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
