class NicknameCheckRequest {
  final String nickname;

  NicknameCheckRequest({required this.nickname});

  Map<String, dynamic> toQuery() {
    return {
      'nickname': nickname,
    };
  }
}
