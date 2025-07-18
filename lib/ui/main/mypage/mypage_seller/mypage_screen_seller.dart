import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/core/network/dio_client.dart';
import 'package:look_talk/core/network/end_points/mypage.dart';
import 'package:look_talk/core/network/token_storage.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/component/common_modal.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/auth/auth_view_model.dart';

import '../../../../view_model/mypage_view_model/alter_member_viewmodel.dart';
import '../../../common/component/common_snack_bar.dart';

class MyPageScreenSeller extends StatelessWidget {
  const MyPageScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = DioClient.instance;
    final viewModel = context.watch<AlterMemberViewmodel>();
    final viewImageUrl = viewModel.alterMember?.member.profileImage;
    final nickName = viewModel.alterMember?.member.nickName ?? '';

    return Scaffold(
      appBar: AppBarSearchCart(title: "마이페이지"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[400],
                  backgroundImage: viewImageUrl != null && viewImageUrl.isNotEmpty
                      ? NetworkImage(viewImageUrl)
                      : null,
                  child: viewImageUrl == null || viewImageUrl.isEmpty
                      ? const Icon(Icons.person, size: 60, color: AppColors.white)
                      : null,
                ),
                gapW16,
                GestureDetector(
                  onTap: () {
                    context.push('/alterMember');
                  },
                  child: Row(
                    children: [
                      Text(
                        nickName,
                        style: const TextStyle(
                          fontSize: TextSizes.headline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                )
              ],
            ),
            gap32,

            // 메뉴 목록
            GestureDetector(
              onTap: () => context.push('/seller/products'),
              child: const _MyPageMenu(title: '상품 조회 / 등록', icon: Icons.inventory_2,),
            ),
            gap16,
            GestureDetector(
              onTap: () => context.push('/seller/orders'),
              child: const _MyPageMenu(title: '주문 조회', icon: Icons.receipt_long,),
            ),
            gap16,
            GestureDetector(
              onTap: () => context.push('/notice'),
              child: const _MyPageMenu(title: '공지사항', icon: Icons.campaign,),
            ),
            gap16,

            // 로그아웃
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CommonModal(
                    title: "로그아웃",
                    content: "정말 로그아웃 하시겠습니까?",
                    confirmText: "로그아웃",
                    onConfirm: () async {
                      CommonSnackBar.show(context, message: '로그아웃이 완료되었습니다.');
                      await TokenStorage().deleteTokens();
                      context.read<AuthViewModel>().logout(context);
                      Navigator.pop(context); // 다이얼로그 닫기
                      context.go('/home');
                    },
                  ),
                );
              },
              child: const _MyPageMenu(title: '로그아웃', icon: Icons.logout,),
            ),
            gap16,

            // 회원탈퇴
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CommonModal(
                    title: "회원탈퇴",
                    content: "작성하신 모든 게시글 및 리뷰도\n사라지게 됩니다. 정말 탈퇴\n하시겠습니까?",
                    confirmText: "회원탈퇴",
                    onConfirm: () async {
                      try {
                        await dio.delete(MyPage.deleteRegister);
                        if (context.mounted) {
                          CommonSnackBar.show(context, message: '회원탈퇴가 완료되었습니다.');
                          Navigator.pop(context); // 다이얼로그 닫기
                          context.go('/home');
                        }
                      } catch (e) {
                        print("회원탈퇴 에러: $e");
                      }
                    },
                  ),
                );
              },
              child: const _MyPageMenu(title: '회원탈퇴', icon: Icons.block,),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPageMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _MyPageMenu({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.darkGrey,),
            gapW24,
            Text(
                title,
                style: context.bodyBold.copyWith(fontWeight: FontWeight.w800)
            ),
          ],
        ),
      ),
    );
  }
}
