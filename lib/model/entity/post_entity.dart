import 'dart:convert';

import 'package:look_talk/model/entity/response/post_response.dart';
import 'package:look_talk/model/entity/response/post_user_response.dart';

import 'comment.dart';

enum PostCategory { question, recommend, my }

PostCategory fromServerValue(String value) {
  switch (value) {
    case 'coord_question':
      return PostCategory.question;
    case 'coord_recommend':
      return PostCategory.recommend;
    case 'my':
      return PostCategory.my;
    default:
      throw ArgumentError('Unknown category: $value');
  }
}

class Post {
  final String id;
  final String title;
  final String content;
  final PostCategory category;
  final String? productId;
  final int likeCount;
  final int commentCount;
  final DateTime createAt;
  final bool isLiked;
  final PostUserResponse user;
  final List<Comment> comments;
  final ProductResponse? product;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.productId,
    required this.likeCount,
    required this.commentCount,
    required this.createAt,
    required this.isLiked,
    required this.user,
    required this.comments,
    this.product,
  });

  // factory Post.fromJson(Map<String, dynamic> json) {
  //   return Post(
  //     id: json['id'],
  //     title: json['title'],
  //     content: json['content'],
  //     category: _mapCategory(json['category']),
  //     productId: json['productId']?.toString(),
  //     likeCount: json['likeCount'] ?? 0,
  //     commentCount: json['commentCount'] ?? 0,
  //     createAt: DateTime.parse(json['createdAt']),
  //   );
  // }

  factory Post.fromResponse(PostResponse response) {
    return Post(
      id: response.id,
      title: response.title,
      content: response.content,
      category: fromServerValue(response.category),
      likeCount: response.likeCount,
      commentCount: response.commentCount,
      productId: null,
      // TODO : 상품 정보 추가 해야함
      createAt: response.createdAt,
      isLiked: response.isLiked,
      user: response.user ?? PostUserResponse.empty(),
      comments: response.comments,
      product: response.product,
    );
  }

  Post copyWith({
    String? id,
    String? title,
    String? content,
    PostCategory? category,
    String? productId,
    int? likeCount,
    int? commentCount,
    DateTime? createAt,
    bool? isLiked,
    PostUserResponse? user,
    List<Comment>? comments,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      productId: productId ?? this.productId,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createAt: createAt ?? this.createAt,
      isLiked: isLiked ?? this.isLiked,
      user: user ?? this.user,
      comments: comments ?? this.comments,
    );
  }
}
