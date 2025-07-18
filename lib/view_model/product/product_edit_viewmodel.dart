import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/model/repository/product_repository.dart';

import '../../ui/common/component/common_snack_bar.dart';

class ProductEditViewModel extends ChangeNotifier {
  final ProductEntity product;
  final ProductRepository repository;

  final stockController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  String status = '판매중';

  File? thumbnailImageFile;

  ProductEditViewModel({
    required this.product,
    required this.repository,
  }) {
    stockController.text = product.stock?.toString() ?? '0';
    priceController.text = product.originalPrice.toString();
    discountController.text = product.discountPercent.toString();
    status = _convertStatusFromServer(product.status);
  }

  void setStatus(String? newStatus) {
    if (newStatus != null) {
      status = newStatus;
      notifyListeners();
    }
  }

  Future<void> pickThumbnailImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      thumbnailImageFile = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> submit(BuildContext context) async {
    try {
      await repository.updateProduct(
        product.productId!,
        stock: int.tryParse(stockController.text) ?? 0,
        status: _convertStatusToServer(status),
        price: int.parse(priceController.text),
        discountRate: int.tryParse(discountController.text),
        thumbnailImage: thumbnailImageFile,
      );

      if (context.mounted) {
        CommonSnackBar.show(context, message: '상품이 수정되었습니다.');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        CommonSnackBar.show(context, message: '상품 수정 실패하였습니다.');
      }
    }
  }

  Future<bool> deleteProduct(BuildContext context) async {
    try {
      await repository.deleteProduct(product.productId!);
      if (context.mounted) {
        CommonSnackBar.show(context, message: '상품이 삭제되었습니다.');
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        CommonSnackBar.show(context, message: '상품 삭제 실패하였습니다.');
      }
      return false;
    }
  }

  String _convertStatusToServer(String localStatus) {
    switch (localStatus) {
      case '판매중':
        return 'on_sale';
      case '판매중지':
        return 'hidden';
      case '품절':
        return 'sold_out';
      default:
        return 'on_sale';
    }
  }

  String _convertStatusFromServer(String? serverStatus) {
    switch (serverStatus) {
      case 'on_sale':
        return '판매중';
      case 'hidden':
        return '판매중지';
      case 'sold_out':
        return '품절';
      default:
        return '판매중';
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
