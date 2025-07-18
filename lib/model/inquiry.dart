class Inquiry {
  final int id;
  final String content;
  final String createdAt;

  Inquiry({required this.id, required this.content, required this.createdAt});

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'],
      content: json['content'],
      createdAt: json['created_at'],
    );
  }
}