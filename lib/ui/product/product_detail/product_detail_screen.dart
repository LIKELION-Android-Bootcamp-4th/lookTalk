import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/product/product_detail/product_detail_bottom_sheet.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedIndex = 0; // 0: 상품정보, 1: 리뷰, 2: 커뮤니티, 3: 문의

  final tabs = ['상품정보', '리뷰', '커뮤니티', '문의'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)), //상단 우측 버튼 3개
          IconButton(onPressed: () {}, icon: const Icon(Icons.home_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상품 이미지
                  Image.network(
                    '상품 이미지 주소 널기',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  // 상품명
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '상품 명',
                      style: TextStyle(
                        fontSize: TextSizes.headline,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 할인율, 원가
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'xx%',
                          style: TextStyle(
                            fontSize: TextSizes.body,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '00,000원',
                          style: TextStyle(
                            fontSize: TextSizes.body,
                            color: Colors.black,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 최종 가격
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '00,000원~',
                      style: TextStyle(
                        fontSize: TextSizes.body,
                        fontWeight: FontWeight.w700,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 탭바 상품정보,리뷰,커뮤니티,문의
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(tabs.length, (index) {
                        final isSelected = index == selectedIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.grey,
                              fontSize: TextSizes.body,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Divider(height: 20),
                  // 선택된 탭 내용
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildTabContent(selectedIndex),
                  ),
                  const SizedBox(height: 80), // 하단 버튼 여백 확보
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFBDBDBD), width: 0.5)), // 연한 회색
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () { //찜하기(위시리스트)버튼
              },
            ),
            const SizedBox(width: 8),
            //구매하기 bottom_sheet 연동
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showOptionBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '구매하기',
                  style: TextStyle(
                    fontSize: TextSizes.body,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget _buildTabContent(int index) {
  switch (index) {
    case 0:
      return const Text(
        '상품 설명 페이지 이미지로 대체 예정',
        style: TextStyle(fontSize: TextSizes.body),
      );
    case 1:
      return const Text(
        '리뷰 페이지',
        style: TextStyle(fontSize: TextSizes.body),
      );
    case 2:
      return const Text(
        '커뮤니티 페이지',
        style: TextStyle(fontSize: TextSizes.body),
      );
    case 3:
      return const Text(
        '문의 페이지',
        style: TextStyle(fontSize: TextSizes.body),
      );
    default:
      return const SizedBox.shrink();
  }
}
