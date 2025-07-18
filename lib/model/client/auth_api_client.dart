import 'package:dio/dio.dart';
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/core/network/end_points/login_manager/auth_endpoints.dart';
import 'package:look_talk/model/entity/response/login_response.dart';
import 'package:look_talk/model/entity/response/user.dart';
import '../entity/request/social_login_request.dart';

class AuthApiClient {
  final Dio _dio;
  AuthApiClient(this._dio);

  Future<ApiResult<LoginResponse>> loginWithSocial({
    required SocialLoginRequest request,
  }) async {
    final response = await _dio.post(
      AuthEndpoints.socialLogin,
      data: request.toJson(),
    );
    return ApiResult.fromResponse(response, (json) => LoginResponse.fromJson(json as Map<String, dynamic>));
  }

  Future<ApiResult<User>> getMe() async {
    final response = await _dio.get('/api/mypage/profile');
    return ApiResult.fromResponse(response, (json) => User.fromJson(json as Map<String, dynamic>));
  }
}
