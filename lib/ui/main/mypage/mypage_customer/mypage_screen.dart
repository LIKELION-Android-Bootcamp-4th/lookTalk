import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/alter_member.dart';
import 'package:look_talk/ui/main/mypage/mypage_screen_product_manage.dart';

class MyPageScreenCustomer extends StatelessWidget {
  const MyPageScreenCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSearchCart(title: "마이페이지",),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 사진/ 이름 영역
            Row(
              children: [

                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[400],
                  child: Icon(Icons.person, size: 60, color: AppColors.white),
                ),
                gapW16,
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_)=> AlterMember()));
                  },
                  child: Row(
                    children: [
                      Text(
                        '이름(닉네임)',
                        style: TextStyle(
                          fontSize: TextSizes.headline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ) ,


                )

              ],
            ),
            gap32,
            const _MyPageMenu(title: '최근 본 상품'),
            gap16,
            const _MyPageMenu(title: '주문/교환/반품/취소 내역',),
            gap16,
            const _MyPageMenu(title: '공지사항'),
            gap16,
            const _MyPageMenu(title: '로그아웃'),
            gap16,
            const _MyPageMenu(title: '회원 탈퇴'),
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
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
