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
import 'package:look_talk/core/network/dio_client.dart'; // 너의 dio 설정 파일 경로

class LoginViewModel with ChangeNotifier {
  String? error;
  dynamic response;

  Future<void> socialLogin({
    required String platformRole,
    required String provider,
    required Map<String, dynamic> authInfo,
  }) async {
    try {
      final dio = DioClient.instance;

      final res = await dio.post('/api/auth/login', data: {
        'email': 'test@kakao.com',  // 일단 테스트용 이메일
        'platformRole': platformRole,
        'provider': provider,
        'authInfo': authInfo,
      });

      print('✅ 서버 응답: ${res.data}');
      response = res.data;
      error = null;
      notifyListeners();
    } catch (e) {
      print('❌ 서버 요청 실패: $e');
      error = '로그인 중 오류가 발생했어요.';
      response = null;
      notifyListeners();
    }
  }
}
