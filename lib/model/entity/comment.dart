import 'package:look_talk/model/entity/response/comment_response.dart';

class Comment {
  final String id;
  final String content;
  final CommentUser user;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.user,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return Comment(
      id: json['id'] as String,
      content: json['content'] as String,
      user: userJson != null
          ? CommentUser.fromJson(userJson as Map<String, dynamic>)
          : CommentUser.unknown(), // 👈 null 처리
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  factory Comment.fromResponse(CommentResponse response) {
    return Comment(
      id: response.id,
      content: response.content,
      createdAt: response.createdAt,
      user: CommentUser(
        nickName: response.nickname,
        profileImageUrl: response.profileImageUrl,
        id: response.userId,
      ),
    );
  }
}

class CommentUser {
  final String id;
  final String nickName;
  final String? profileImageUrl;

  CommentUser({required this.id, required this.nickName, this.profileImageUrl});

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'] as String,
      nickName: json['nickName'] as String,
      profileImageUrl: json['profileImageUrl'],
    );
  }

  factory CommentUser.unknown() {
    return CommentUser(
      id: '',
      nickName: '알 수 없음',
      profileImageUrl: null,
    );
  }
}
