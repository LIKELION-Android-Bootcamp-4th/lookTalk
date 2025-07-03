import '../client/auth_api_client.dart';
import '../entity/request/social_login_request.dart';
import '../entity/response/social_login_response.dart';

class AuthRepository {
  final AuthApiClient client;

  AuthRepository({required this.client});

  Future<SocialLoginResponse> socialLogin({
    required String platformRole,
    required String provider,
    required Map<String, dynamic> authInfo,
  }) async {

    final request = SocialLoginRequest(
      platformRole: platformRole,
      provider: provider,
      authInfo: authInfo,
    );

    return await client.socialLogin(request);
  }
}
