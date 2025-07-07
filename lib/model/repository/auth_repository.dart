import 'package:look_talk/model/entity/request/social_login_request.dart';
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/model/entity/response/login_response.dart';
import '../client/auth_api_client.dart';

// api client 를 호출해서 로그인 결과를 그대로 반환
class AuthRepository {
  final AuthApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<ApiResult<LoginResponse>> loginWithSocial({
    required SocialLoginRequest request,
  }) {
    return apiClient.loginWithSocial(request: request);
  }
}
