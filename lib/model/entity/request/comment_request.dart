class CommentRequest {
  final String content;

  CommentRequest({required this.content});

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}
