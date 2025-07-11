// view_model/selected_product_view_model.dart
import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/search_response.dart';

class SelectedProductViewModel extends ChangeNotifier {
  ProductSearch? _selectedProduct;

  ProductSearch? get selectedProduct => _selectedProduct;

  void selectProduct(ProductSearch? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  void deselectProduct(){
    _selectedProduct = null;
    notifyListeners();
  }

  void clear() {
    _selectedProduct = null;
    notifyListeners();
  }
}
