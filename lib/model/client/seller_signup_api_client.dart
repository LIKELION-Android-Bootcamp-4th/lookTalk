import 'package:dio/dio.dart';
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/core/network/end_points/login_manager/auth_endpoints.dart';

import '../entity/request/seller_signup_request.dart';

class SellerSignupApiClient {
  final Dio _dio;

  SellerSignupApiClient(this._dio);

  Future<ApiResult<void>> submitSellerSignup({
    required SellerSignupRequest request,
  }) async {
    final response = await _dio.post(
      AuthEndpoints.sellerSignUp,
      data: request.toJson(),
    );
    return ApiResult.fromVoidResponse(response);
  }
}
