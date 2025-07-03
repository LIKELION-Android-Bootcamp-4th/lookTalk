import 'package:dio/dio.dart';

import '../../core/network/endpoints.dart';
import '../entity/request/social_login_request.dart';
import '../entity/response/social_login_response.dart';

class AuthApiClient {
  final Dio dio;

  AuthApiClient({required this.dio});

  Future<SocialLoginResponse> socialLogin(SocialLoginRequest request) async {
    final response = await dio.post(
      Endpoints.socialLogin,
      data: request.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Company-Code': 'eyJhbGciOiJIUzI1NiI',
        },
      ),
    );

    return SocialLoginResponse.fromJson(response.data);
  }
}
