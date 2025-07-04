// import 'package:flutter/material.dart';
// import 'package:look_talk/model/entity/response/social_login_response.dart';
//
// import '../../model/repository/auth_repository.dart';
//
// class LoginViewModel extends ChangeNotifier {
//   final AuthRepository repository;
//
//   LoginViewModel({required this.repository});
//
//   bool isLoading = false;
//   SocialLoginResponse? response;
//   String? error;
//
//   Future<void> socialLogin({
//     required String platformRole,
//     required String provider,
//     required Map<String, dynamic> authInfo,
//   }) async {
//     isLoading = true;
//     error = null;
//     notifyListeners();
//
//     try {
//       final result = await repository.socialLogin(
//         platformRole: platformRole,
//         provider: provider,
//         authInfo: authInfo,
//       );
//       response = result;
//     } catch (e) {
//       error = '소셜 로그인 실패: ${e.toString()}';
//     }
//
//     isLoading = false;
//     notifyListeners();
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/network/dio_client.dart';

import '../../model/client/auth_api_client.dart';

class LoginViewModel with ChangeNotifier {
  final AuthApiClient _authApiClient = AuthApiClient();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> onSocialLoginSuccess({
    required String email,
    required String provider,
    required BuildContext context,
  }) async {
    try {
      final result = await _authApiClient.checkUserExists(
        email: email,
        provider: provider,
      );

      if (result.exists) {
        // TODO: 기존 회원이면 이전 화면으로
        Navigator.pop(context);
      } else {
        // TODO: 신규 회원 -> 회원가입 시작
        context.pushReplacement('/signup?email=$email&provider=$provider');
      }
    } catch (e) {
      _errorMessage = '서버 오류가 발생했습니다.';
      notifyListeners();
    }
  }

}
