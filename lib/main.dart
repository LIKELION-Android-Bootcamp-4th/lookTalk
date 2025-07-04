import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/view_model/auth/login_view_model.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/ui/main/community/community_my_tab.dart';
import 'package:look_talk/view_model/community/community_tab_view_model.dart';
import 'package:look_talk/view_model/community/community_view_model.dart';
import 'package:provider/provider.dart';
import 'core/app.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '2be79d6c89568bf54e78a7e7b1bc3fbc');
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommunityTabViewModel()),
        ChangeNotifierProvider(create: (_) => CommunityViewModel(PostRepository())),
        ChangeNotifierProvider(create: (_) => LoginViewModel())
      ],
      child: MyApp()));
}
