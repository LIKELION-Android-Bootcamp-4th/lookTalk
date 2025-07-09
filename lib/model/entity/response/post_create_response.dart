class PostCreateResponse {
  final String id;

  PostCreateResponse({required this.id});

  factory PostCreateResponse.fromJson(Map<String, dynamic> json) {
    return PostCreateResponse(
      id: json['id'],
    );
  }
}
