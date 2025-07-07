import 'package:dio/dio.dart';
import 'package:look_talk/core/network/dio_client.dart';
import 'package:look_talk/core/network/token_storage.dart';
import 'package:look_talk/model/entity/response/login_response.dart';

import '../../core/network/api_result.dart';
import '../../core/network/endpoints.dart';
import '../entity/request/social_login_request.dart';

// dio 를 이용해 서버 api 를 직접 호출
class AuthApiClient {
  final Dio _dio;

  AuthApiClient(this._dio);

  Future<ApiResult<LoginResponse>> loginWithSocial({
    required SocialLoginRequest request,
  }) async {
    final response = await _dio.post(
      Endpoints.socialLogin,
      data: request.toJson(),
    );
    return ApiResult.fromResponse(response, LoginResponse.fromJson);
  }
}

