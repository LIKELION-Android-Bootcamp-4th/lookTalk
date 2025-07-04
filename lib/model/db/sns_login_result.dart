class SnsLoginResult {
  final bool exists;
  final UserInfo? user;

  SnsLoginResult({
    required this.exists,
    required this.user,
  });

  factory SnsLoginResult.fromJson(Map<String, dynamic> json) {
    return SnsLoginResult(
      exists: json['exists'],
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
    );
  }
}

class UserInfo {
  final String id;
  final String email;
  final String nickname;
  final String provider;

  UserInfo({
    required this.id,
    required this.email,
    required this.nickname,
    required this.provider,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      provider: json['provider'],
    );
  }
}
