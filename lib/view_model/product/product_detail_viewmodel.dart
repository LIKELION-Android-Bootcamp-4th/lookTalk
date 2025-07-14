import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/model/repository/product_repository.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository repository;
  final String productId;

  int selectedIndex = 0;
  bool isWishlist = false;
  int wishlistCount = 0;

  final List<String> tabs = ['상품정보', '리뷰', '커뮤니티', '문의'];

  Product? product;

  ProductDetailViewModel(this.repository, this.productId) {
    fetchProductDetail();
  }

  Future<void> fetchProductDetail() async {
    try {
      final result = await repository.fetchProductDetail(productId);
      product = result;

      wishlistCount = result.dynamicFields?['wishlistCount'] ?? 0;

      notifyListeners();
    } catch (e) {
      print('상품 상세 불러오기 실패: $e');
    }
  }

  int get discountPercent => product?.discountPercent ?? 0;
  int get originalPrice => product?.originalPrice ?? 0;
  int get finalPrice => product?.finalPrice ?? 0;
  String get productName => product?.name ?? '';
  String get imageUrl => product?.thumbnailImagePath ?? '';
  int get price => product?.price ?? 0;
  String get category => product?.category ?? '';
  String get storeName => product?.storeName ?? '판매자 정보 없음';

  void selectTab(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
    }
  }

  /// 찜 상태 변경 (실제 서버 요청 필요 시 API 호출 추가)
  void toggleWishlist() {
    isWishlist = !isWishlist;
    wishlistCount += isWishlist ? 1 : -1;
    notifyListeners();
  }
}
