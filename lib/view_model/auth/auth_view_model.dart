// view_model/auth_view_model.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';

import '../../model/client/auth_api_client.dart';
import '../../model/entity/request/auth_info.dart';

class AuthViewModel with ChangeNotifier {
  final AuthApiClient apiClient;

  AuthViewModel(this.apiClient);

  Future<void> loginAndNavigate(BuildContext context, AuthInfo authInfo, String provider) async {
    final navigator = Navigator.of(context);

    //print('login and navigate : ${authInfo.toJson()}, provider : $provider');

    navigator.push(MaterialPageRoute(builder: (_) => const CommonLoading()));

    try{
      final result = await apiClient.loginWithSocial(
        provider: provider,
        platformRole: 'buyer', // TODO : 일단 buyer로 보내고 나중에 UPDATE
        authInfo: authInfo,
      );

      Navigator.of(context).pop();

      result.when(success: (res) {
        if (res.user.isNewUser) {
          context.go('/signup');
        } else {
          context.pop(); // TODO: 이전 화면으로 잘 가는지 확인
        }
      }, error: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.errorMessage ?? '로그인 실패')),
        );
      });
    }catch(e){
      if(navigator.canPop()) navigator.pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서버 연걸 실패')),
      );
    }

  }
}
