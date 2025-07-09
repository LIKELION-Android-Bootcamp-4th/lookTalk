// lib/main.dart

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
import 'package:look_talk/view_model/mypage_view_model/notice_viewmodel.dart';
import 'package:look_talk/view_model/viewmodel_provider.dart';
import 'package:provider/provider.dart';
import 'core/app.dart';
import 'ui/main/home/home_screen.dart';
// [✅ viewmodel_provider.dart 임포트 추가]
import 'view_model/viewmodel_provider.dart';

// 기존 Provider import들
import 'view_model/community/community_tab_view_model.dart';
import 'view_model/community/community_view_model.dart';
import 'model/repository/post_repository.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommunityTabViewModel()),
        ChangeNotifierProvider(create: (_) => CommunityViewModel(PostRepository())),
        ChangeNotifierProvider(create: (_) => provideAuthViewModel()),
        ChangeNotifierProvider(create: (_) => provideNicknameCheckViewModel()),

        // [✅ CartViewModel Provider를 함수 호출로 변경]
        ChangeNotifierProvider(create: (_) => provideCartViewModel()),
        ChangeNotifierProvider(
          create: (_) => NoticeViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// 기존 MyApp 코드 예시 (프로젝트 상황에 따라 다를 수 있음)
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // [✅ key 파라미터 추가 권장]

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LookTalk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(), // 예시 홈 화면 위젯
    );
  }
}