class PostUserResponse {
  final String id;
  final String nickName;
  final String? profileImageUrl;

  PostUserResponse({
    required this.id,
    required this.nickName,
    this.profileImageUrl,
  });

  factory PostUserResponse.fromJson(Map<String, dynamic> json) {
    return PostUserResponse(
      id: json['id'] as String,
      nickName: json['nickName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }


}
