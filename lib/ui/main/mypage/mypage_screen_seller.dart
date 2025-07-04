import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/main/mypage/mypage_screen_product_manage.dart';

class MyPageScreenSeller extends StatelessWidget {
  const MyPageScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("마이페이지"),
        titleTextStyle: TextStyle(
            fontFamily: "NanumSquareRoundB.ttf",
            fontSize: TextSizes.headline,
            color: AppColors.black,
            fontWeight: FontWeight.w300
        ),
        ),
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
                Text(
                  '회사명',
                  style: TextStyle(
                    fontSize: TextSizes.headline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            gap32,

            _MyPageMenu(title: '상품 조회 / 등록', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyPageProductManageScreen()),
              );
            }),
            gap16,
            const _MyPageMenu(title: '주문 조회',),
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
