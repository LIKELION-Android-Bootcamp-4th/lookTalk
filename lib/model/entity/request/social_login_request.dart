
import 'social_login_request.dart';

class SocialLoginRequest {
  final String provider;      // ex: "kakao", "google", "naver"
  final String platformRole;  // ex: "buyer", "seller"
  final AuthInfo authInfo;    // OAuth2 토큰 정보

  SocialLoginRequest({
    required this.provider,
    required this.platformRole,
    required this.authInfo,
  });

  factory SocialLoginRequest.fromJson(Map<String, dynamic> json) {
    return SocialLoginRequest(
      provider: json['provider'] as String,
      platformRole: json['platformRole'] as String,
      authInfo: AuthInfo.fromJson(json['authInfo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'platformRole': platformRole,
      'authInfo': authInfo.toJson(),
    };
  }
}


class AuthInfo {
  final String accessToken;
  final String tokenType;
  final String refreshToken;
  final int expiresIn;
  final String scope;
  final int refreshTokenExpiresIn;

  AuthInfo({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.expiresIn,
    required this.scope,
    required this.refreshTokenExpiresIn,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
      scope: json['scope'] as String,
      refreshTokenExpiresIn: json['refresh_token_expires_in'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'scope': scope,
      'refresh_token_expires_in': refreshTokenExpiresIn,
    };
  }

}
