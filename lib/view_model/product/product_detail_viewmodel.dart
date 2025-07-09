import 'package:flutter/cupertino.dart';
import '../../model/entity/product_entity.dart';
import '../../model/repository/product_repository.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository _repository;
  final String _productId;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Product? _product;
  Product? get product => _product;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool _isWishlist = false;
  bool get isWishlist => _isWishlist;

  final List<String> tabs = ['상품정보', '리뷰', '커뮤니티', '문의'];

  ProductDetailViewModel(this._repository, this._productId) {
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    _isLoading = true;
    notifyListeners();

    try {
      _product = await _repository.fetchProductDetail(_productId);
    } catch (e) {
      print('상품 상세 정보 불러오기 실패 (ViewModel): $e');
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectTab(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void toggleWishlist() {
    _isWishlist = !_isWishlist;
    notifyListeners();
  }
}
