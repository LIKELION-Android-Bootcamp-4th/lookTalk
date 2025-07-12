  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:look_talk/core/extension/text_style_extension.dart';
  import 'package:look_talk/model/entity/request/nickname_request.dart';
  import 'package:look_talk/ui/common/component/common_text_field.dart';
  import 'package:look_talk/ui/common/component/primary_button.dart';
  import 'package:look_talk/view_model/auth/buyer_signup_view_model.dart';
  import 'package:provider/provider.dart';

  import '../../view_model/auth/nickname_check_view_model.dart';
  import '../common/const/colors.dart';
  import '../common/const/gap.dart';

  class BuyerInfoScreen extends StatelessWidget {
    const BuyerInfoScreen({super.key});

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
              _buildText(),
              gap8,
              _buildNicknameTextField(context),
              gap4,
              _buildNicknameStatusText(context),
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

    Widget _buildText(){
      return Text('닉네임');
    }

    Widget _buildNicknameTextField(BuildContext context) {
      return Consumer<CheckNameViewModel>(
        builder: (context, viewModel, child) {
          return CommonTextField(
            onChanged: (value) {
              viewModel.check(CheckNameType.nickname ,value);
            },
          );
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

    Widget _buildStartButton() {
      return Consumer<BuyerSignupViewModel>(
        builder: (context, signupViewModel, child) {
          final nicknameViewModel = context.watch<CheckNameViewModel>();
          final isAvailable = nicknameViewModel.isAvailable ?? false;
          final nickname = nicknameViewModel.result?.nickname ?? '';
          final isLoading = signupViewModel.isLoading;

          return PrimaryButton(
            text: isLoading ? '가입 중...' : '시작하기',
            borderRadius: BorderRadius.circular(10),
            backgroundColor: isAvailable ? AppColors.secondary : Colors.grey,
            height: 60,
            onPressed: isAvailable && !isLoading
                ? () async {
              final result = await signupViewModel.submitSignup(nickname);

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
                const SnackBar(
                  content: Text('사용 가능한 닉네임을 입력해주세요.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          );
        },
      );
    }
  }
  // TODO: 서버 요청하고 서버 응답 오기전까지 로딩화면 띄우기!!
  // class BuyerInfoScreen extends StatelessWidget {
  //   const BuyerInfoScreen({super.key});
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: _buildAppBar(context),
  //       body: Consumer<BuyerSignupViewModel>(
  //         builder: (context, signupViewModel, _) {
  //           return Stack(
  //             children: [
  //               _buildMainContent(context),
  //               if (signupViewModel.isLoading)
  //                 Container(
  //                   color: Colors.black.withOpacity(0.3),
  //                   child: const Center(child: CommonLoading()),
  //                 ),
  //             ],
  //           );
  //         },
  //       ),
  //     );
  //   }
  //
  //   PreferredSizeWidget _buildAppBar(BuildContext context) {
  //     return AppBar(
  //       actions: [
  //         IconButton(
  //           onPressed: () => context.push('/home'),
  //           icon: const Icon(Icons.home_outlined),
  //         ),
  //       ],
  //     );
  //   }
  //
  //   Widget _buildMainContent(BuildContext context) {
  //     return Padding(
  //       padding: const EdgeInsets.all(32.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildWelcomeText(context),
  //           gap48,
  //           const Text('닉네임'),
  //           gap8,
  //           _buildNicknameTextField(context),
  //           gap4,
  //           _buildNicknameStatusText(context),
  //           const Spacer(),
  //           _buildStartButton(),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   Widget _buildWelcomeText(BuildContext context) {
  //     return Text(
  //       'LookTalk에\n오신 것을 환영해요!',
  //       style: context.h1.copyWith(fontSize: 25),
  //     );
  //   }
  //
  //   Widget _buildNicknameTextField(BuildContext context) {
  //     return Consumer<NicknameCheckViewModel>(
  //       builder: (context, viewModel, child) {
  //         return CommonTextField(
  //           onChanged: (value) {
  //             viewModel.checkNickname(value);
  //           },
  //         );
  //       },
  //     );
  //   }
  //
  //   Widget _buildNicknameStatusText(BuildContext context) {
  //     final viewModel = context.watch<NicknameCheckViewModel>();
  //     final result = viewModel.nicknameResult;
  //
  //     if (viewModel.isLoading) {
  //       return const Text('닉네임 확인 중...', style: TextStyle(color: Colors.grey));
  //     }
  //
  //     if (result == null) {
  //       return const SizedBox.shrink();
  //     }
  //
  //     return Text(
  //       result.available ? '사용 가능한 닉네임입니다.' : '이미 사용 중인 닉네임입니다.',
  //       style: TextStyle(
  //         fontSize: 14,
  //         color: result.available ? AppColors.green : AppColors.red,
  //       ),
  //     );
  //   }
  //
  //   Widget _buildStartButton() {
  //     return Consumer<BuyerSignupViewModel>(
  //       builder: (context, signupViewModel, child) {
  //         final nicknameViewModel = context.watch<NicknameCheckViewModel>();
  //         final isAvailable = nicknameViewModel.isAvailable ?? false;
  //         final nickname = nicknameViewModel.nicknameResult?.nickname ?? '';
  //
  //         return PrimaryButton(
  //           text: '시작하기',
  //           borderRadius: BorderRadius.circular(10),
  //           backgroundColor: isAvailable ? AppColors.secondary : Colors.grey,
  //           height: 60,
  //           onPressed: isAvailable
  //               ? () async {
  //             final result = await signupViewModel.submitSignup(nickname);
  //
  //             if (context.mounted) {
  //               if (result.success) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text("LookTalk에 오신 것을 환영해요!")),
  //                 );
  //                 context.go('/home');
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text(result.message),
  //                     duration: const Duration(seconds: 2),
  //                   ),
  //                 );
  //               }
  //             }
  //           }
  //               : () {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text('사용 가능한 닉네임을 입력해주세요.'),
  //                 duration: Duration(seconds: 2),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     );
  //   }
  // }
