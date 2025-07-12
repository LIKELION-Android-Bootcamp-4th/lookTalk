class PostListRequest {
  final int page;
  final int limit;
  final String? category;
  final String? userId;
  final String? sortBy;
  final String? sortOrder;

  const PostListRequest({
    required this.page,
    required this.limit,
    this.category,
    this.userId,
    this.sortBy,
    this.sortOrder,
  });

  PostListRequest copyWith({
    int? page,
    int? limit,
    String? category,
    String? userId,
    String? sortBy,
    String? sortOrder,
  }) {
    return PostListRequest(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      category: category ?? this.category,
      userId: userId ?? this.userId,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
      if (category != null) 'category': category,
      if (userId != null) 'userId': userId,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
    };
  }
}
