  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:look_talk/core/extension/text_style_extension.dart';
  import 'package:look_talk/ui/common/component/common_text_field.dart';
  import 'package:look_talk/view_model/auth/seller_signup_view_model.dart';
  import 'package:provider/provider.dart';

  import '../../model/entity/request/nickname_request.dart';
  import '../../view_model/auth/nickname_check_view_model.dart';
  import '../common/component/primary_button.dart';
  import '../common/const/colors.dart';
  import '../common/const/gap.dart';

  class SellerInfoScreen extends StatelessWidget {
    const SellerInfoScreen({super.key});

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
              gap24,
              _buildCompanyText(),
              gap8,
              _buildNameTextField(context),
              gap4,
              _buildNicknameStatusText(context),
              gap16,
              _buildDescriptionText(),
              gap8,
              _buildDescriptionTextField(context),
              gap4,
              const Spacer(),
              _buildStartButton(),
            ],
          ),
        ),
      );
    }

    PreferredSizeWidget _buildAppBar(BuildContext context) {
      return AppBar(
        actions: [
          IconButton(
            onPressed: () => context.push('/home'),
            icon: Icon(Icons.home_outlined),
          ),
        ],
      );
    }

    Widget _buildWelcomeText(BuildContext context) {
      return Text(
        'LookTalk에\n오신 것을 환영해요!',
        style: context.h1.copyWith(fontSize: 25),
      );
    }

    Widget _buildCompanyText() {
      return Text('회사명');
    }

    Widget _buildNameTextField(BuildContext context) {
      final checkNameViewModel = context.read<CheckNameViewModel>();
      final signupViewModel = context.read<SellerSignupViewmodel>();

      return CommonTextField(
        controller: signupViewModel.nameController, // ✅ 이게 있어야 .text가 정상 작동
        onChanged: (value) {
          checkNameViewModel.check(CheckNameType.storeName, value);
        },
      );
    }

    Widget _buildNicknameStatusText(BuildContext context) {
      final viewModel = context.watch<CheckNameViewModel>();
      final result = viewModel.result;

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

    Widget _buildDescriptionText() {
      return Text('회사 설명');
    }

    Widget _buildDescriptionTextField(BuildContext context) {
      final vm = context.read<SellerSignupViewmodel>();
      return CommonTextField(controller: vm.descriptionController);
    }

    Widget _buildStartButton() {
      return Consumer<SellerSignupViewmodel>(
        builder: (context, signupViewModel, _) {
          final checkNameViewModel = context.watch<CheckNameViewModel>();

          final isAvailable = checkNameViewModel.isAvailable ?? false;
          final storeName = signupViewModel.nameController.text.trim();
          final description = signupViewModel.descriptionController.text.trim();
          final isLoading = signupViewModel.isLoading;

          final canSubmit = isAvailable && description.isNotEmpty && !isLoading;

          return PrimaryButton(
            text: isLoading ? '가입 중...' : '시작하기',
            borderRadius: BorderRadius.circular(10),
            backgroundColor: canSubmit ? AppColors.primary : Colors.grey,
            height: 60,
            onPressed: canSubmit
                ? () async {
              final result = await signupViewModel.submitSignup(
                storeName,
                description,
              );

              if (context.mounted) {
                if (result.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("LookTalk에 오신 것을 환영해요!")),
                  );
                  context.go('/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.message),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            }
                : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isLoading
                        ? '로딩 중입니다.'
                        : !isAvailable
                        ? '사용 가능한 상점명을 입력해주세요.'
                        : '회사 설명을 입력해주세요.',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          );
        },
      );
    }

  }
