import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/model/client/seller_product_api_client.dart';

import '../../model/repository/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductViewModel(this._productRepository);

  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productRepository.getProducts(); // ✅
    } catch (e) {
      print('상품 불러오기 실패: $e');
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
