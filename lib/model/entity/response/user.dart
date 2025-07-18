class User {
  final String id;
  final String email;
  final String nickName;
  final List<String> loginRoles;
  final List<String> platformRoles;
  final bool isNewUser;
  final String companyCode;

  User({
    required this.id,
    required this.email,
    required this.nickName,
    required this.loginRoles,
    required this.platformRoles,
    required this.isNewUser,
    required this.companyCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('유저 구조!!!! $json');
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nickName: json['nickName'] ?? '',
      loginRoles: (json['loginRoles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      platformRoles: (json['platformRoles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isNewUser: json['isNewUser'] ?? false,
      companyCode: json['companyCode'] ?? '',
    );
  }

  /// 메인 역할 판단 (마이페이지 분기용)
  String get mainRole {
    if (platformRoles.contains('seller')) return 'seller';
    return 'buyer';
  }
}
