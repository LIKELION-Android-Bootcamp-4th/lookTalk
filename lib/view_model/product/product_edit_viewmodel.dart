import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/model/repository/product_repository.dart';

class ProductEditViewModel extends ChangeNotifier {
  final Product product;
  final ProductRepository repository;

  final stockController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  String status = '판매중';

  ProductEditViewModel({
    required this.product,
    required this.repository,
  });

  void setStatus(String? newStatus) {
    if (newStatus != null) {
      status = newStatus;
      notifyListeners();
    }
  }

  void submit() {
    print('상품명: ${product.name}');
    print('상품번호: ${product.productId}');
    print('재고: ${stockController.text}');
    print('판매상태: $status');
    print('정가: ${priceController.text}');
    print('할인율: ${discountController.text}');
  }

  Future<bool> deleteProduct(BuildContext context) async {
    try {
      await repository.deleteProduct(product.productId!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상품이 삭제되었습니다.')),
        );
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상품 삭제 실패')),
        );
      }
      return false;
    }
  }

  @override
  void dispose() {
    stockController.dispose();
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }
}
