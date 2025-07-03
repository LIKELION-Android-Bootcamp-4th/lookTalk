class SocialLoginResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  const SocialLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    return SocialLoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;
  final String email;
  final String name;

  const User({
    required this.id,
    required this.email,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}
