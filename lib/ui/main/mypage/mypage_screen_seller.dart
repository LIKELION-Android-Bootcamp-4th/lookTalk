import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/common/const/gap.dart';

class MyPageScreenSeller extends StatelessWidget {
  const MyPageScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 사진/ 이름 영역
          Row(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 60, color: AppColors.white),
              ),
              gapW16,
              const Text(
                '회사명',
                style: TextStyle(
                  fontSize: TextSizes.headline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          gap32,

          const _MyPageMenu(title: '상품 조회 / 등록'),
          const _MyPageMenu(title: '주문 조회'),
          const _MyPageMenu(title: '공지사항'),
          const _MyPageMenu(title: '로그아웃'),
          const _MyPageMenu(title: '회원 탈퇴'),
        ],
      ),
    );
  }
}

class _MyPageMenu extends StatelessWidget {
  final String title;

  const _MyPageMenu({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: () {
          // 메뉴 클릭시 이동 아직 안됨
        },
        child: Text(
          title,
          style: const TextStyle(
            fontSize: TextSizes.body,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
