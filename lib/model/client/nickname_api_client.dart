import 'package:dio/dio.dart';
import 'package:look_talk/model/entity/request/nickname_request.dart';

import '../../core/network/api_result.dart';
import '../../core/network/end_points/login_manager/auth_endpoints.dart';
import '../entity/response/nickname_check_response.dart';

// dio 를 이용해 닉네임 중복 확인 api 를 직접 호출
class NicknameApiClient {
  final Dio _dio;

  NicknameApiClient(this._dio);

  Future<ApiResult<NicknameCheckResponse>> checkNicknameAvailable(
    NicknameCheckRequest request,
  ) async {
    final response = await _dio.get(
      AuthEndpoints.nicknameCheck,
      queryParameters: request.toQuery()
    );

    return ApiResult.fromResponse(response, (json) => NicknameCheckResponse.fromJson(json as Map<String, dynamic>));
  }
}
