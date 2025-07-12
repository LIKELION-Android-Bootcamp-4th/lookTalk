import 'package:flutter/cupertino.dart';
import 'package:look_talk/model/product_dummy.dart';
import '../../model/entity/product_entity.dart';

class ProductViewModel extends ChangeNotifier {
  // 상품 목록 (초기값: 더미 데이터로 설정)
  final List<Product> _products = ProductRepository.dummyProducts();

  List<Product> get products => List.unmodifiable(_products);

  // 상품 추가
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }
}
