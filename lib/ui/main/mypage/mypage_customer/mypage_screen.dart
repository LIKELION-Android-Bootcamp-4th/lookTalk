import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/network/dio_client.dart';
import 'package:look_talk/core/network/end_points/mypage.dart';
import 'package:look_talk/core/network/token_storage.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/component/common_modal.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/notice.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/recent_product.dart';
import 'package:look_talk/view_model/auth/auth_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/mypage_view_model/alter_member_viewmodel.dart';
import '../mypage_seller/mypage_screen_seller.dart';

class MyPageScreenCustomer extends StatefulWidget {
  const MyPageScreenCustomer({super.key});

  @override
  State<MyPageScreenCustomer> createState() => _MyPageScreenCustomerState();
}

class _MyPageScreenCustomerState extends State<MyPageScreenCustomer> {
  bool _hasAccessToken = false;
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void initState() {
    super.initState();
    _checkAccessToken();
  }



  Future<void> _checkAccessToken() async {
    final token = await _tokenStorage.getAccessToken();
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AlterMemberViewmodel>();
    final viewImageUrl = viewModel.alterMember?.member.profileImage;
    final dio = DioClient.instance;
    return Scaffold(
      appBar: AppBarSearchCart(title: "마이페이지",),
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
                  ? Icon(Icons.person, size: 60, color: AppColors.white)
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
                        "${viewModel.alterMember?.member.nickName}",
                        style: TextStyle(
                          fontSize: TextSizes.headline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                )
              ],
            ),
            gap32,
            GestureDetector(
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RecentProduct()))
              },
              child: _MyPageMenu(title: '최근 본 상품'),
            ),
              gap16,
              GestureDetector(
                onTap: () =>
                {
                  context.push('/manageProduct')
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>MyPageScreenSeller())),
                },
                child: _MyPageMenu(title: '주문/교환/반품/취소'),
              ),
              gap16,
              GestureDetector(
                onTap: () =>
                {
                  context.push('/seller/orders'),
                 // context.push('/notice')
                },
                child: _MyPageMenu(title: '공지사항'),
              ),
              gap16,
              // GestureDetector(
              //   onTap: () {
              //     showDialog(
              //       context: context,
              //       builder: (context) => CommonModal(
              //         title: "로그아웃",
              //         content: "로그아웃 하시겠습니까?",
              //         confirmText: "로그아웃 하기",
              //         onConfirm: () {
              //         },
              //       ),
              //     );
              //   },
              //   child: _MyPageMenu(title: '로그아웃'),
              // ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        CommonModal(
                          title: "로그아웃",
                          content: "정말 로그아웃 하시겠습니까?",
                          confirmText: "로그아웃",
                          onConfirm: () async {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("로그아웃이 완료되었습니다."),));
                            await TokenStorage().deleteTokens();
                            context.read<AuthViewModel>().logout(context);
                            Navigator.pop(context);
                            context.go('/home');
                          },
                        ),
                  );
                },
                child: _MyPageMenu(title: '로그아웃'),
              ),
              gap16,

              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        CommonModal(
                          title: "회원탈퇴",
                          content: "작성하신 모든 게시글 및 리뷰도\n 사라지게 됩니다. 정말 탈퇴\n 하시겠습니까?",
                          confirmText: "회원탈퇴",
                          onConfirm: () async {
                            try {
                              await dio.delete(MyPage.deleteRegister);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("회원탈퇴가 완료되었습니다."),));
                                Navigator.pop(context);
                                context.go('/home');
                              }
                            } catch (e) {
                              print("회원탈퇴 에러 발생$e");
                            }
                          },
                        ),
                  );
                },
                child: _MyPageMenu(title: '회원탈퇴'),
              ),

          ],
        ),
      ),
    );
  }
}

class _MyPageMenu extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _MyPageMenu({
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
              fontFamily: "NanumSquareRoundB.ttf",
              fontSize: TextSizes.body,
              color: AppColors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
