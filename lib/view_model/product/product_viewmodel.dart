import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/model/repository/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository;

  ProductViewModel(this._repository) {
    // ViewModel이 생성될 때 자동으로 상품 목록 불러오기
    fetchProducts();
  }

  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
    } catch (e) {
      print('상품 목록 불러오기 실패: $e');
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
