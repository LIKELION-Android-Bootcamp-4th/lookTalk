// lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:look_talk/view_model/auth/auth_view_model.dart';
import 'package:look_talk/view_model/mypage_view_model/notice_viewmodel.dart';
import 'package:look_talk/view_model/viewmodel_provider.dart';
import 'package:provider/provider.dart';

import 'core/app.dart';
import 'ui/main/home/home_screen.dart';
// [✅ viewmodel_provider.dart 임포트 추가]
import 'view_model/viewmodel_provider.dart';

// 기존 Provider import들
import 'view_model/community/community_tab_view_model.dart';
import 'model/repository/post_repository.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
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