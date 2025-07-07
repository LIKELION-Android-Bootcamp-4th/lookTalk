import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:provider/provider.dart';

import '../../model/entity/request/social_login_request.dart';
import '../../view_model/auth/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(72.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeText(context),
            gap24,
            _buildLoginButtons(context, vm),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => context.pushReplacement('/home'),
          icon: Icon(Icons.home),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Text(
      'LookTalk에\n오신 것을 환영해요!',
      style: context.h1.copyWith(fontSize: 25),
    );
  }

  Widget _buildLoginButtons(BuildContext context, AuthViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          gap32,
          _buildLoginButton('assets/images/kakao_login.png', () async {
            await _handleKakaoLogin(context, vm);
          }),
          gap16,
          _buildLoginButton('assets/images/naver_login.png', () async {
            await _handleNaverLogin(context, vm);
          }),
          gap16,
          _buildLoginButton('assets/images/google_login.png', () async {
            await _handleGoogleLogin(context, vm);
          }),
        ],
      ),
    );
  }

  Widget _buildLoginButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(assetPath, width: 250, height: 50, fit: BoxFit.fill),
    );
  }

  Future<void> _handleKakaoLogin(BuildContext context, AuthViewModel vm) async {
    try {
      kakao.OAuthToken token;

      if (await kakao.isKakaoTalkInstalled()) {
        try {
          token = await kakao.UserApi.instance.loginWithKakaoTalk();
          print('1 ');
        } catch (error) {
          print('2 ');
          if (error is PlatformException &&
              error.code == 'NotSupportError' &&
              error.message?.contains('not connected') == true) {
            debugPrint('[Kakao] KakaoTalk 연결 안됨, 웹 로그인으로 대체');
            token = await kakao.UserApi.instance.loginWithKakaoAccount();
          } else {
            rethrow;
          }
        }
      } else {
        token = await kakao.UserApi.instance.loginWithKakaoAccount();
        print('3 ');
      }

      // 사용자 정보 조회
      final kakaoUser = await kakao.UserApi.instance.me();
      final email = kakaoUser.kakaoAccount?.email;

      if (email != null) {
        final authInfo = AuthInfo(
          accessToken: token.accessToken,
          tokenType: 'bearer',
          refreshToken: token.refreshToken ?? '',
          expiresIn: 21599,
          scope: 'account_email profile',
          refreshTokenExpiresIn: 5184000,
        );

        print('login and navigate : ${authInfo.toJson()}');

        // 로그인 결과 서버로 전달
        await vm.loginAndNavigate(context, authInfo, 'kakao');
      } else {
        _showError(context, '이메일을 가져올 수 없습니다.');
        print('4 ');
      }
    } catch (e) {
      _showError(context, '카카오 로그인 실패: $e');
      print('5 : $e');
    }
  }

  Future<void> _handleNaverLogin(BuildContext context, AuthViewModel vm) async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.loggedIn) {
        final account = result.account;
        final token = await FlutterNaverLogin.getCurrentAccessToken();

        if (account != null && account.email != null) {
          final authInfo = AuthInfo(
            accessToken: token.accessToken,
            tokenType: 'bearer',
            refreshToken: token.refreshToken ?? '',
            expiresIn: 21599,
            scope: 'account_email profile',
            refreshTokenExpiresIn: 5184000,
          );

          await vm.loginAndNavigate(context, authInfo, 'naver');
        } else {
          _showError(context, '이메일을 가져올 수 없습니다.');
        }
      } else {
        _showError(context, '네이버 로그인 실패');
      }
    } catch (e) {
      _showError(context, '네이버 로그인 실패: $e');
    }
  }

  Future<void> _handleGoogleLogin(
    BuildContext context,
    AuthViewModel vm,
  ) async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      final GoogleSignInAccount user = await signIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      final GoogleSignInClientAuthorization? auth = await user
          .authorizationClient
          .authorizationForScopes(['email', 'profile']);

      if (auth == null) {
        _showError(context, '권한 요청 실패');
        return;
      }

      final authInfo = AuthInfo(
        accessToken: auth.accessToken,
        tokenType: 'bearer',
        refreshToken: '',
        expiresIn: 3600,
        scope: 'email profile',
        refreshTokenExpiresIn: 0,
      );

      await vm.loginAndNavigate(context, authInfo, 'google');
    } catch (e) {
      _showError(context, '구글 로그인 실패: $e');
      print(e);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
