import 'package:look_talk/model/client/buyer_signup_api_client.dart';

import '../../core/network/api_result.dart';
import '../entity/request/buyer_signup_request.dart';

class BuyerSignupRepository {
  final BuyerSignupApiClient apiClient;

  BuyerSignupRepository(this.apiClient);

  Future<ApiResult<void>> submitBuyerSignup({
    required BuyerSignupRequest request,
  }) async {
    return apiClient.submitBuyerSignup(request: request);
  }
}
