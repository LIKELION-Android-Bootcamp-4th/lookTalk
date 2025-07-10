import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:look_talk/view_model/community/post_create_view_model.dart';
import 'package:look_talk/view_model/community/selected_product_view_model.dart';
import 'package:look_talk/view_model/mypage_view_model/notice_viewmodel.dart';
import 'package:look_talk/view_model/viewmodel_provider.dart';
import 'package:provider/provider.dart';

import 'core/app.dart';

void main() async {
  KakaoSdk.init(
    nativeAppKey: '2be79d6c89568bf54e78a7e7b1bc3fbc',
    loggingEnabled: true,
  );
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '297394298746-334r4944egru9obvf9au90es85pvv5va.apps.googleusercontent.com',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectedProductViewModel()),
        ChangeNotifierProvider(create: (_) => provideAuthViewModel()),
        ChangeNotifierProvider(create: (_) => NoticeViewModel()..loadNotices()),
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
      child: MyApp(),
    ),
  );
}
