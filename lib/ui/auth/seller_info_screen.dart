import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';

import '../common/component/primary_button.dart';
import '../common/const/colors.dart';
import '../common/const/gap.dart';

class SellerInfoScreen extends StatelessWidget {
  final String email;
  final String provider;
  final String role;

  const SellerInfoScreen({
    super.key,
    required this.email,
    required this.provider,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeText(context),
            gap48,
            Text('회사명'),
            gap8,
            CommonTextField(),
            gap4,
            const Spacer(),
            _buildStartButton()
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context){
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => context.push('/home'),
          icon: Icon(Icons.home_outlined),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context){
    return Text(
      'LookTalk에\n오신 것을 환영해요!',
      style: context.h1.copyWith(fontSize: 25),
    );
  }

  Widget _buildStartButton() {
    return PrimaryButton(
      text: '시작하기',
      borderRadius: BorderRadius.circular(10),
      backgroundColor: AppColors.secondary,
      height: 60,
      onPressed: () {},
    );
  }
}