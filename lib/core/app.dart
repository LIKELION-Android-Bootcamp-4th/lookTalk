import 'package:flutter/material.dart';
import 'package:look_talk/core/router/router.dart';
import 'package:look_talk/core/theme/app_theme.dart';

import '../ui/common/const/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LookTalk',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      color: AppColors.white,
      theme: AppTheme.light(),
    );
  }
}
