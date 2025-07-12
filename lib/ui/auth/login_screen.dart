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
    final vm = context.read<AuthViewModel>();

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
          icon: const Icon(Icons.home),
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
        } catch (error) {
          if (error is PlatformException && error.code == 'NotSupportError') {
            token = await kakao.UserApi.instance.loginWithKakaoAccount();
          } else {
            rethrow;
          }
        }
      } else {
        token = await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      final authInfo = AuthInfo(
        accessToken: token.accessToken,
        tokenType: 'bearer',
        refreshToken: token.refreshToken,
        idToken: token.idToken,
        expiresIn: token.expiresAt.difference(DateTime.now()).inSeconds,
        scope: token.scopes?.join(' '),
        refreshTokenExpiresIn: token.refreshTokenExpiresAt?.difference(DateTime.now()).inSeconds,
      );
      await vm.handleSocialLogin(context, authInfo, 'kakao');

    } catch (e) {
      _showError(context, '카카오 로그인 실패: $e');
    }
  }

  Future<void> _handleNaverLogin(BuildContext context, AuthViewModel vm) async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.loggedIn) {
        final token = await FlutterNaverLogin.getCurrentAccessToken();

        final authInfo = AuthInfo(
          accessToken: token.accessToken,
          tokenType: token.tokenType,
          refreshToken: token.refreshToken,
        );
        await vm.handleSocialLogin(context, authInfo, 'naver');
      } else {
        _showError(context, '네이버 로그인 실패: ${result.errorMessage}');
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
      // 1. GoogleSignIn() 생성자를 사용하여 인스턴스를 만듭니다.
      final GoogleSignIn signIn = GoogleSignIn();
      // 2. signIn() 메서드를 호출하여 로그인을 시도합니다.
      final GoogleSignInAccount? user = await signIn.signIn();

      if (user == null) {
        _showError(context, '구글 로그인 취소');
        return;
      }

      // 3. authentication getter를 통해 인증 정보를 가져옵니다.
      final GoogleSignInAuthentication auth = await user.authentication;

      // 4. accessToken이 null인지 확인합니다.
      if (auth.accessToken == null) {
        _showError(context, '구글 토큰 정보를 가져올 수 없습니다.');
        return;
      }

      // 5. AuthInfo 객체를 올바르게 생성합니다.
      final authInfo = AuthInfo(
        accessToken: auth.accessToken!,
        tokenType: 'bearer',
        idToken: auth.idToken,
      );

      await vm.handleSocialLogin(context, authInfo, 'google');
    } catch (e) {
      _showError(context, '구글 로그인 실패: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
