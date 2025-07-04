import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

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

  Widget _buildLoginButtons(BuildContext context, LoginViewModel vm) {
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
          _buildLoginButton('assets/images/google_login.png', () {
            // TODO: 구글 로그인 처리
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

  Future<void> _handleKakaoLogin(
    BuildContext context,
    LoginViewModel vm,
  ) async {
    try {
      if (await kakao.isKakaoTalkInstalled()) {
        await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      final kakaoUser = await kakao.UserApi.instance.me();
      final email = kakaoUser.kakaoAccount?.email;

      if (email != null) {
        await vm.onSocialLoginSuccess(
          email: email,
          provider: 'kakao',
          context: context,
        );
      } else {
        _showError(context, '이메일을 가져올 수 없습니다.');
      }
    } catch (e) {
      _showError(context, '카카오 로그인 실패: $e');
    }
  }

  Future<void> _handleNaverLogin(
    BuildContext context,
    LoginViewModel vm,
  ) async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.loggedIn) {
        final account = result.account;

        if (account != null && account.email != null) {
          await vm.onSocialLoginSuccess(
            email: account.email!,
            provider: 'naver',
            context: context,
          );
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

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
