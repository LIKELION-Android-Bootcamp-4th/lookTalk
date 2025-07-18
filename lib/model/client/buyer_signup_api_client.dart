import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/login_manager/auth_endpoints.dart';
import 'package:look_talk/model/entity/request/buyer_signup_request.dart';

import '../../core/network/api_result.dart';

class BuyerSignupApiClient {
  final Dio _dio;

  BuyerSignupApiClient(this._dio);

  Future<ApiResult<void>> submitBuyerSignup({
    required BuyerSignupRequest request,
  }) async {
    final response = await _dio.patch(
      AuthEndpoints.buyerSignUp,
      data: request.toJson()
    );
    return ApiResult.fromVoidResponse(response);
  }
}
