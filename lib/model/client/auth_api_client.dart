import 'package:dio/dio.dart';
import 'package:look_talk/core/network/dio_client.dart';
import 'package:look_talk/core/network/token_storage.dart';
import 'package:look_talk/model/entity/response/login_response.dart';

import '../../core/network/api_result.dart';
import '../../core/network/endpoints.dart';
import '../entity/request/auth_info.dart';

class AuthApiClient {
  final Dio _dio = DioClient.instance;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<ApiResult<LoginResponse>> loginWithSocial({
    required String provider,
    required AuthInfo authInfo,
    required String platformRole,
  }) async {
    final response = await _dio.post(
      Endpoints.socialLogin,
      data: {
        'provider': provider,
        'platformRole': platformRole,
        'authInfo': authInfo.toJson(),
      },
    );
    return ApiResult.fromResponse(response, LoginResponse.fromJson);
  }


}

