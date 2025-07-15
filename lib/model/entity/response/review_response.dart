import 'package:look_talk/model/entity/review_entity.dart';

class ReviewResponse {
  final String id;
  final String productId;
  final String userId;
  final String nickname;
  final String? userProfileImage;
  final int rating;
  final String content;
  final List<String> imageUrls;
  final int likeCount;
  final bool likedByCurrentUser;
  final String createdAt;

  ReviewResponse({
    required this.id,
    required this.productId,
    required this.userId,
    required this.nickname,
    required this.userProfileImage,
    required this.rating,
    required this.content,
    required this.imageUrls,
    required this.likeCount,
    required this.likedByCurrentUser,
    required this.createdAt,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      id: json['id'],
      productId: json['productId'],
      userId: json['userId'],
      nickname: json['nickname'],
      userProfileImage: json['userProfileImage'],
      rating: json['rating'],
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      likeCount: json['likeCount'] ?? 0,
      likedByCurrentUser: json['likedByCurrentUser'] ?? false,
      createdAt: json['createdAt'],
    );
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      productId: productId,
      userId: userId,
      nickname: nickname,
      userProfileImage: userProfileImage,
      rating: rating,
      content: content,
      imageUrls: imageUrls,
      likeCount: likeCount,
      likedByCurrentUser: likedByCurrentUser,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
