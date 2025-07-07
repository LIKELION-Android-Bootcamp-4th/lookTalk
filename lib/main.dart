import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:look_talk/core/network/dio_client.dart';
import 'package:look_talk/model/client/auth_api_client.dart';
import 'package:look_talk/model/client/nickname_api_client.dart';
import 'package:look_talk/model/repository/auth_repository.dart';
import 'package:look_talk/model/repository/nickname_respository.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/view_model/auth/auth_view_model.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/ui/main/community/community_my_tab.dart';
import 'package:look_talk/view_model/auth/nickname_check_view_model.dart';
import 'package:look_talk/view_model/community/community_tab_view_model.dart';
import 'package:look_talk/view_model/community/community_view_model.dart';
import 'package:provider/provider.dart';
import 'core/app.dart';

void main() async {
  final dio = DioClient.instance;

  KakaoSdk.init(nativeAppKey: '2be79d6c89568bf54e78a7e7b1bc3fbc', loggingEnabled: true);
  await GoogleSignIn.instance.initialize(
    serverClientId: '297394298746-334r4944egru9obvf9au90es85pvv5va.apps.googleusercontent.com'
  );

  AuthViewModel provideAuthViewModel() => AuthViewModel(AuthRepository(AuthApiClient(dio)));
  NicknameCheckViewModel provideNicknameCheckViewModel() => NicknameCheckViewModel(NicknameRepository(NicknameApiClient(dio)));

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommunityTabViewModel()),
        ChangeNotifierProvider(create: (_) => CommunityViewModel(PostRepository())),
        ChangeNotifierProvider(create: (_) => provideAuthViewModel()),
        ChangeNotifierProvider(create: (_) => provideNicknameCheckViewModel())
      ],
      child: MyApp()));
}
