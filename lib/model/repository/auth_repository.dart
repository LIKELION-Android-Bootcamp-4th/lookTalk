
//
// class AuthRepository {
//   final AuthApiClient client;
//
//   AuthRepository({required this.client});
//
//   Future<SocialLoginResponse> socialLogin({
//     required String platformRole,
//     required String provider,
//     required Map<String, dynamic> authInfo,
//   }) async {
//
//     final request = SocialLoginRequest(
//       platformRole: platformRole,
//       provider: provider,
//       authInfo: authInfo,
//     );
//
//     return await client.socialLogin(request);
//   }
// }
