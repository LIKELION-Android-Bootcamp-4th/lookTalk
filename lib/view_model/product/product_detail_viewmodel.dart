import 'package:flutter/cupertino.dart';
import '../../model/entity/product_entity.dart';
import '../../model/repository/product_repository.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository _repository;
  final String _productId;

  ProductDetailViewModel(this._repository, this._productId) {
    fetchDetail();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Product? _product;
  Product? get product => _product;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  final List<String> tabs = ['상품정보', '리뷰', '커뮤니티', '문의'];

  bool _isWishlisted = false;
  bool get isWishlisted => _isWishlisted;

  Future<void> fetchDetail() async {
    _isLoading = true;
    notifyListeners();

    try {
      _product = await _repository.fetchProductDetail(_productId);
      _isWishlisted = _product?.isWishlisted ?? false;
    } catch (e) {
      print('상품 상세 정보 불러오기 실패 (ViewModel): $e');
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectTab(int index) {
    if (_tabIndex != index) {
      _tabIndex = index;
      notifyListeners();
    }
  }

  void toggleWishlist() {
    _isWishlisted = !_isWishlisted;
    // TODO: 서버에 찜하기 상태 업데이트 API 호출
    notifyListeners();
  }
}
