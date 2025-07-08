class PostCreateRequest {
  final String category;
  final String title;
  final String content;
  final String? productId;
  final String? mainImage;

  PostCreateRequest({
    required this.category,
    required this.title,
    required this.content,
    this.productId,
    this.mainImage,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'title': title,
    'content': content,
    if (productId != null) 'productId': productId,
    if (mainImage != null)
      'images': {
        'main': mainImage,
      },
  };
}
