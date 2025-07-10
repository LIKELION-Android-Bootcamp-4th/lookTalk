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
    print('유저 구조!!!! $json');
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nickName: json['nickName'] ?? '',
      loginRoles: (json['loginRoles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      platformRoles: (json['platformRoles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      isNewUser: json['isNewUser'] ?? false,
    );
  }
}
