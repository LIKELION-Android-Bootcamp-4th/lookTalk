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
      id: json['id']?.toString() ?? '',
      nickName: json['nickName']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  factory PostUserResponse.empty() {
    return PostUserResponse(
      id: '',
      nickName: '알 수 없음',
      profileImageUrl: null,
    );
  }



}
