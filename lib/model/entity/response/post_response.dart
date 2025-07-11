import 'package:look_talk/model/entity/response/post_user_response.dart';

class PostResponse {
  final String id;
  final String title;
  final String content;
  final String category;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final PostUserResponse? user;
  final PostImageUrls? images;
  final bool isLiked;

  PostResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.user,
    this.images,
    required this.isLiked,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    print("PostResponse.fromJson 호출됨: ${json['title']}");

    return PostResponse(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'],
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      user: json['user'] != null ? PostUserResponse.fromJson(json['user']) : null,
      images: json['images'] != null ? PostImageUrls.fromJson(json['images']) : null,
      isLiked: json['isLiked'] ?? false
    );
  }
}

class PostImageUrls {
  final String? main;
  final List<String>? sub;

  PostImageUrls({this.main, this.sub});

  factory PostImageUrls.fromJson(Map<String, dynamic> json) {
    return PostImageUrls(
      main: json['main'] as String?,
      sub: (json['sub'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
}

