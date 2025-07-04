enum PostCategory { question, recommend, my }

class Post {
  final String id;
  final String title;
  final String content;
  final PostCategory category;
  final int? productId; // TODO: 타입 확인 필요
  final int likeCount;
  final int commentCount;
  final DateTime createAt; // TODO: json -> post 변환할때 parse해야함

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.productId,
    required this.likeCount,
    required this.commentCount,
    required this.createAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      category: _mapCategory(json['category']),
      productId: json['productId'] is int ? json['productId'] : null,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createAt: DateTime.parse(json['createdAt']),
    );
  }

  static PostCategory _mapCategory(String value) {
    switch (value) {
      case 'question':
        return PostCategory.question;
      case 'recommend':
        return PostCategory.recommend;
      default:
        return PostCategory.my;
    }
  }

}
