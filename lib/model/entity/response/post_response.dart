import 'package:look_talk/model/entity/response/comment_response.dart';
import 'package:look_talk/model/entity/response/post_user_response.dart';

import '../comment.dart';

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
  final List<Comment> comments;
  final ProductResponse? product;

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
    required this.comments,
    this.product,
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
      isLiked: json['isLiked'],
      comments: (json['comments'] as List<dynamic>?) ?.map((e) => Comment.fromJson(e)).toList() ?? [],
      product: json['product'] != null ? ProductResponse.fromJson(json['product']) : null,
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

class ProductResponse {
  final String id;
  final String name;
  final int price;
  final String? thumbnailImageUrl;

  ProductResponse({
    required this.id,
    required this.name,
    required this.price,
    this.thumbnailImageUrl,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      thumbnailImageUrl: json['thumbnailImageUrl'],
    );
  }
}



