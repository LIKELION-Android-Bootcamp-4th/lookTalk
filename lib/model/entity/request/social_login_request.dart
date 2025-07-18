class SocialLoginRequest {
  final String provider;
  final String? platformRole;
  final AuthInfo authInfo;

  SocialLoginRequest({
    required this.provider,
    required this.platformRole,
    required this.authInfo,
  });

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
  final String? tokenType;
  final String? refreshToken;
  final int? expiresIn;
  final String? scope;
  final int? refreshTokenExpiresIn;
  final String? idToken;

  AuthInfo({
    required this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.expiresIn,
    this.scope,
    this.refreshTokenExpiresIn,
    this.idToken,
  });

  Map<String, dynamic> toJson() {
    // 서버로 보낼 때, null이 아닌 값만 포함하여 보냅니다.
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'scope': scope,
      'refresh_token_expires_in': refreshTokenExpiresIn,
      'id_token': idToken,
    }..removeWhere((key, value) => value == null);
  }
}
