// lib/model/entity/response/user.dart

class User {
  final String id;
  final String email;
  final String nickName;
  final List<String> loginRoles;
  final List<String> platformRoles;
  final bool isNewUser;

  User({
    required this.id,
    required this.email,
    required this.nickName,
    required this.loginRoles,
    required this.platformRoles,
    required this.isNewUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      nickName: json['nickName'] as String,
      loginRoles: List<String>.from(json['loginRoles']),
      platformRoles: List<String>.from(json['platformRoles']),
      isNewUser: json['isNewUser'] as bool,
    );
  }
}
