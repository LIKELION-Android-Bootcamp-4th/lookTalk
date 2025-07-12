class NicknameCheckResponse {
  final bool available;
  final String nickname;
  final String message;

  NicknameCheckResponse({
    required this.available,
    required this.nickname,
    required this.message,
  });

  factory NicknameCheckResponse.fromJson(Map<String, dynamic> json) {
    return NicknameCheckResponse(
      available: json['available'] as bool,
      nickname: json['nickname'] as String,
      message: json['message'] as String,
    );
  }
}
