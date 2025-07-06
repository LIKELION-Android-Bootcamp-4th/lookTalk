
import 'package:look_talk/model/entity/response/user.dart';

class LoginResponse {
  final User user;

  LoginResponse({required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    return LoginResponse(
      user: User.fromJson(userJson),
    );
  }
}
