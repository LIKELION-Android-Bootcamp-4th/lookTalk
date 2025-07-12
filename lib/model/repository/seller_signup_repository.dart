import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/model/client/seller_signup_api_client.dart';

import '../entity/request/seller_signup_request.dart';

class SellerSignupRepository {
  final SellerSignupApiClient apiClient;

  SellerSignupRepository(this.apiClient);

  Future<ApiResult<void>> submitSellerSignup({
    required SellerSignupRequest request,
  }) async {
    return apiClient.submitSellerSignup(request: request);
  }
}
