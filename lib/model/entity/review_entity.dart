class ReviewEntity {
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
  final DateTime createdAt;

  ReviewEntity({
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

  factory ReviewEntity.fromJson(Map<String, dynamic> json) {
    return ReviewEntity(
      id: json['id'],
      productId: json['productId'] ?? '', // fallback 처리
      userId: json['createdBy'] ?? '',
      nickname: json['user']?['nickName'] ?? '알 수 없음',
      userProfileImage: null, // API에 없다면 null
      rating: json['rating'],
      content: json['comment'],
      imageUrls: (json['images'] as List<dynamic>)
          .map((e) => e['url'] as String)
          .toList(),
      likeCount: json['likeCount'],
      likedByCurrentUser: json['likedByCurrentUser'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
