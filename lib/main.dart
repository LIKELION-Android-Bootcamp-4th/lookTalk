import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:look_talk/view_model/mypage_view_model/notice_viewmodel.dart';
import 'package:look_talk/view_model/viewmodel_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:look_talk/view_model/product/product_register_viewmodel.dart';
import 'core/app.dart';
import 'core/network/dio_client.dart';

void main() async {

  final dio = DioClient.instance;

  KakaoSdk.init(nativeAppKey: '2be79d6c89568bf54e78a7e7b1bc3fbc', loggingEnabled: true);
  await GoogleSignIn.instance.initialize(
    serverClientId: '297394298746-334r4944egru9obvf9au90es85pvv5va.apps.googleusercontent.com'
  );

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => provideAuthViewModel()),
        ChangeNotifierProvider(
          create: (_) => NoticeViewModel()..loadNotices(),
        ),
        ChangeNotifierProvider<ProductViewModel>(
          create: (_) => ProductViewModel(dio)..fetchProducts(),
        ),
        ChangeNotifierProvider<ProductRegisterViewModel>(
          create: (_) => ProductRegisterViewModel(dio),
        ),
        ChangeNotifierProvider(
          create: (_) => provideHomeProductListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => provideHomeCategoryViewModel(),
        ),
      ],
      child: MyApp()));
}
