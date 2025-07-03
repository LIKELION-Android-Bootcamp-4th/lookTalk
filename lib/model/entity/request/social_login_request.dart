class SocialLoginRequest {
  final String platformRole;
  final String provider;
  final Map<String, dynamic> authInfo;

  const SocialLoginRequest({
    required this.platformRole,
    required this.provider,
    required this.authInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'platformRole': platformRole,
      'provider': provider,
      'authInfo': authInfo,
    };
  }
}
