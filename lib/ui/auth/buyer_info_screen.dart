import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';
import 'package:look_talk/ui/common/component/primary_button.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth/nickname_check_view_model.dart';
import '../common/const/colors.dart';
import '../common/const/gap.dart';

class BuyerInfoScreen extends StatelessWidget {

  const BuyerInfoScreen({
    super.key,
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
            Text('닉네임'),
            gap8,
            _buildNicknameTextField(context),
            gap4,
            _buildNicknameStatusText(context),
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

  Widget _buildNicknameTextField(BuildContext context){
    return Consumer<NicknameCheckViewModel>(
      builder: (context, viewModel, child) {
        return CommonTextField(
          onChanged: (value) {
            viewModel.checkNickname(value);
          },
        );
      },
    );
  }

  Widget _buildNicknameStatusText(BuildContext context) {
    final viewModel = context.watch<NicknameCheckViewModel>();
    final result = viewModel.nicknameResult;

    if (viewModel.isLoading) {
      return const Text('닉네임 확인 중...', style: TextStyle(color: Colors.grey));
    }

    if (result == null) {
      return const SizedBox.shrink();
    }

    return Text(
      result.available ? '사용 가능한 닉네임입니다.' : '이미 사용 중인 닉네임입니다.',
      style: TextStyle(
        fontSize: 14,
        color: result.available ? AppColors.green : AppColors.red,
      ),
    );
  }

  Widget _buildStartButton() {
    return PrimaryButton(
      text: '시작하기',
      borderRadius: BorderRadius.circular(10),
      backgroundColor: AppColors.secondary,
      height: 60,
      onPressed: () async {
        
      },
    );
  }
}
