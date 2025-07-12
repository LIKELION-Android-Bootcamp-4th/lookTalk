import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/network/token_storage.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';

import '../../model/client/auth_api_client.dart';
import '../../model/entity/request/social_login_request.dart';
import '../../model/repository/auth_repository.dart';

// auth repository 를 호출 & ui 상태 관리
class AuthViewModel with ChangeNotifier {
  final AuthRepository repository;
  final TokenStorage _tokenStorage = TokenStorage();

  AuthViewModel(this.repository);

  Future<bool> isLoggedIn() async{
    final accessToken = await _tokenStorage.getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<void> loginAndNavigate(
    BuildContext context,
    AuthInfo authInfo,
    String provider,
  ) async {
    final navigator = Navigator.of(context);

    //print('login and navigate : ${authInfo.toJson()}, provider : $provider');

    navigator.push(MaterialPageRoute(builder: (_) => const CommonLoading()));

    try {
      final request = SocialLoginRequest(
        provider: provider,
        platformRole: 'buyer', // TODO : 일단 buyer로 보내고 나중에 UPDATE
        authInfo: authInfo,
      );

      final result = await repository.loginWithSocial(request: request);

      if(context.mounted) Navigator.of(context).pop();

      if (result.success && result.data != null) {
        final user = result.data!;
        final accessToken = user.accessToken;
        final refreshToken = user.refreshToken;
        final userId = user.user.id;

        print('로그인 성공 → userId: $userId');
        print('accessToken: $accessToken');
        print('refreshToken: $refreshToken');
        print('userId: $userId');

        await _tokenStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken, userId: userId);

        if (user.user.isNewUser) {
          context.go('/signup');
        } else {
          if(context.canPop()){
            context.pop(); // TODO: 이전 화면으로 잘 가는지 확인
          }else{
            context.go('/home');
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      if (navigator.canPop()) navigator.pop();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('서버 연걸 실패')));
    }
  }
}
