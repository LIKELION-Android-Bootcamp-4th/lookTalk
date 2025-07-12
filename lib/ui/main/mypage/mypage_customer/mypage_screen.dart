import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/component/common_modal.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/alter_member.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/manage_product_screen.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/notice.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/recent_product.dart';

import 'package:look_talk/ui/main/mypage/mypage_seller/mypage_screen_seller.dart';

import 'package:look_talk/ui/main/mypage/mypage_seller/mypage_screen_product_manage.dart';


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
            GestureDetector(
              onTap: ()=> {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> RecentProduct())),
              },
              child: _MyPageMenu(title: '최근 본 상품'),
            ),

            gap16,
            GestureDetector(
              onTap: ()=> {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> ManageProductScreen())),
              },
              child:  _MyPageMenu(title: '주문/교환/반품/취소'),
            ),
            gap16,
            GestureDetector(
              onTap: ()=> {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> NoticeScreen())),
              },
              child:  _MyPageMenu(title: '공지사항'),
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
                Navigator.push(context, MaterialPageRoute(builder: (_)=> MyPageScreenSeller()));
              },
              child: _MyPageMenu(title: '로그아웃'),
            ),
            gap16,
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CommonModal(
                    title: "회원탈퇴",
                    content: "작성하신 모든 게시글 및 리뷰도\n 사라지게 됩니다. 정말 탈퇴\n 하시겠습니까?",
                    confirmText: "회원탈퇴 하기",
                    onConfirm: () {
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
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
