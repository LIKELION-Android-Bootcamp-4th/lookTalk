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
    final data = json['data'] as Map<String, dynamic>;

    return NicknameCheckResponse(
      available: data['available'] as bool,
      nickname: data['nickname'] as String,
      message: data['message'] as String,
    );
  }
}
