import 'package:flutter/material.dart';

class ProductDetailViewModel extends ChangeNotifier {
  int selectedIndex = 0;
  bool isWishlist = false;

  final List<String> tabs = ['상품정보', '리뷰', '커뮤니티', '문의'];
  String productName = '상품 명';
  String imageUrl = '상품이미지';
  int discountPercent = 20;
  int originalPrice = 50000;
  int finalPrice = 40000;

  void selectTab(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  void toggleWishlist() {
    isWishlist = !isWishlist;
    // 찜기능
    notifyListeners();
  }
}
