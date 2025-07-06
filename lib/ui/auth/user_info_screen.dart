import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';
import 'package:look_talk/ui/common/component/primary_button.dart';

import '../common/const/colors.dart';
import '../common/const/gap.dart';

class UserInfoScreen extends StatelessWidget {
  final String email;
  final String provider;
  final String role;

  const UserInfoScreen({
    super.key,
    required this.email,
    required this.provider,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.push('/home'),
            icon: Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LookTalk에\n오신 것을 환영해요!',
              style: context.h1.copyWith(fontSize: 25),
            ),
            gap48,
            Text('닉네임'),
            gap8,
            CommonTextField(),
            gap4,
            Text('여기'),
            Spacer(),
            PrimaryButton(text: '시작하기',
                borderRadius: BorderRadius.circular(10),
                backgroundColor: AppColors.secondary,
                height: 60,
                onPressed: (){})
          ],
        ),
      ),
    );
  }
}
