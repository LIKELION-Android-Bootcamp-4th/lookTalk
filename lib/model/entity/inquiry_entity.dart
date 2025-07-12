class Inquiry {
  final String id;
  final String title;
  final String content;
  final String productId;
  final DateTime createdAt;

  Inquiry({
    required this.id,
    required this.title,
    required this.content,
    required this.productId,
    required this.createdAt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      productId: json['productId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}