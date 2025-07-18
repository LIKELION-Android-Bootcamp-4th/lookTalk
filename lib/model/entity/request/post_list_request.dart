class PostListRequest {
  final int page;
  final int limit;
  final String? category;
  final String? userId;
  final String? productId;
  final SortType sortBy;
  final SortOrder sortOrder;

  const PostListRequest({
    required this.page,
    required this.limit,
    this.category,
    this.userId,
    this.productId,
    this.sortBy = SortType.createdAt,
    this.sortOrder = SortOrder.desc,
  });

  PostListRequest copyWith({
    int? page,
    int? limit,
    String? category,
    String? userId,
    String? productId,
    SortType? sortBy,
    SortOrder? sortOrder,
  }) {
    return PostListRequest(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      category: category ?? this.category,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
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
      if (productId != null) 'productId': productId,
      'sortBy': sortBy.value,
      'sortOrder': sortOrder.value,
    };
  }
}

// enum 정의는 클래스 위에 위치
enum SortType {
  createdAt,
  likeCount,
  commentCount,
}

extension SortTypeExtension on SortType {
  String get label {
    switch (this) {
      case SortType.createdAt:
        return '최근 등록순';
      case SortType.likeCount:
        return '좋아요순';
      case SortType.commentCount:
        return '댓글순';
    }
  }

  String get value {
    switch (this) {
      case SortType.createdAt:
        return 'createdAt';
      case SortType.likeCount:
        return 'likeCount';
      case SortType.commentCount:
        return 'commentCount';
    }
  }
}

enum SortOrder {
  asc,
  desc,
}

extension SortOrderExtension on SortOrder {
  String get label {
    switch (this) {
      case SortOrder.asc:
        return '오름차순';
      case SortOrder.desc:
        return '내림차순';
    }
  }

  String get value {
    switch (this) {
      case SortOrder.asc:
        return 'asc';
      case SortOrder.desc:
        return 'desc';
    }
  }
}

extension SortTypeFromString on SortType {
  static SortType fromLabel(String label) {
    return SortType.values.firstWhere((e) => e.label == label, orElse: () => SortType.createdAt);
  }
}
