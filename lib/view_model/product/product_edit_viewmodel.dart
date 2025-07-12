import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/product_entity.dart';

class ProductEditViewModel extends ChangeNotifier {
  final Product product;

  final stockController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  String status = '판매중';

  ProductEditViewModel({required this.product});

  void setStatus(String? newStatus) {
    if (newStatus != null) {
      status = newStatus;
      notifyListeners();
    }
  }

  void submit() {
    print('상품명: ${product.name}');
    print('상품번호: ${product.code}');
    print('재고: ${stockController.text}');
    print('판매상태: $status');
    print('정가: ${priceController.text}');
    print('할인율: ${discountController.text}');
  }

  @override
  void dispose() {
    stockController.dispose();
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }
}
