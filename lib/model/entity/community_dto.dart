class CommunitySearch {
  final String id;
  final String title;
  final String content;
  final int viewCount;
  final int likeCount;
  final bool isLiked;
  final String authorName;

  CommunitySearch({
    required this.id,
    required this.title,
    required this.content,
    required this.viewCount,
    required this.likeCount,
    required this.isLiked,
    required this.authorName,
  });

  factory CommunitySearch.fromJson(Map<String, dynamic> json) {
    return CommunitySearch(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      viewCount: json['viewCount'],
      likeCount: json['likeCount'],
      isLiked: json['isLiked'],
      authorName: json['author']['name'],
    );
  }
}