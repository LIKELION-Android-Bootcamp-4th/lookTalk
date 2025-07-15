// lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:look_talk/view_model/community/post_create_view_model.dart';
import 'package:look_talk/view_model/community/selected_product_view_model.dart';
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


void main() async {
  KakaoSdk.init(nativeAppKey: '2be79d6c89568bf54e78a7e7b1bc3fbc', loggingEnabled: true);
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: '297394298746-334r4944egru9obvf9au90es85pvv5va.apps.googleusercontent.com',
  );
  await googleSignIn.signInSilently();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectedProductViewModel()),
        ChangeNotifierProvider(create: (_) => provideAuthViewModel()),
        ChangeNotifierProvider(create: (_) => provideCheckNameViewModel()),
        ChangeNotifierProvider(create: (_) => provideCategoryDataSelectViewmodel()),
        ChangeNotifierProvider(create: (_) => provideOrderViewModel()),


        ChangeNotifierProvider(create: (_) => provideSearchMyProductListViewmodel()),

        // [✅ CartViewModel Provider를 함수 호출로 변경]
        ChangeNotifierProvider(create: (_) => provideCartViewModel()),
        ChangeNotifierProvider(
          create: (_) => NoticeViewModel(),
        ),
        ChangeNotifierProxyProvider<SelectedProductViewModel, PostCreateViewModel>(
          create: (_) => providePostCreateViewModel(),
          update: (_, selectedVM, postVM) {
            final selected = selectedVM.selectedProduct;
            if (selected != null) {
              postVM!.setProductId(selected.id);
            }
            return postVM!;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

