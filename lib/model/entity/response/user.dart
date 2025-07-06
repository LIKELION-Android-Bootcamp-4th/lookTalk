// lib/model/entity/response/user.dart

import 'profile.dart';

class User {
  final String id;
  final String email;
  final String nickName;
  final Profile profile;
  final List<String> loginRoles;
  final List<String> platformRoles;
  final bool isNewUser;
  final String accessToken;
  final String refreshToken;

  User({
    required this.id,
    required this.email,
    required this.nickName,
    required this.profile,
    required this.loginRoles,
    required this.platformRoles,
    required this.isNewUser,
    required this.accessToken,
    required this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      nickName: json['nickName'] as String,
      profile: Profile.fromJson(json['profile']),
      loginRoles: List<String>.from(json['loginRoles']),
      platformRoles: List<String>.from(json['platformRoles']),
      isNewUser: json['isNewUser'] as bool,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
