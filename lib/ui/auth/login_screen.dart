import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';

import '../../core/network/dio_client.dart';
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
            //await _handleKakaoLogin(context, vm);
            _handleKakaoLogin(context, vm);
          }),
          gap16,
          _buildLoginButton('assets/images/naver_login.png', () {
            // TODO: 네이버 로그인 처리
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
      child: Image.asset(
        assetPath,
        width: 250,
        height: 50,
        fit: BoxFit.fill,
      ),
    );
  }

  Future<void> _handleKakaoLogin(BuildContext context, LoginViewModel vm) async {
    try {
      final installed = await isKakaoTalkInstalled();
      final token = installed
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final authInfo = {
        'access_token': token.accessToken,
        'refresh_token': token.refreshToken,
        'token_type': 'bearer',
        'expires_in': 21599,
        'refresh_token_expires_in': 5184000,
        'scope': 'account_email profile',
      };

      await vm.socialLogin(
        platformRole: 'buyer', // or 'seller'
        provider: 'kakao',
        authInfo: authInfo,
      );

      if (vm.response != null) {
        // TODO: 서버 응답으로 새 유저인지 아닌지 판단 후 분기
        context.go('/home'); // 또는 '/select-role'
      } else if (vm.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.error!)),
        );
      }
    } catch (e) {
      print('카카오 로그인 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 로그인 실패')),
      );
    }
  }



}
