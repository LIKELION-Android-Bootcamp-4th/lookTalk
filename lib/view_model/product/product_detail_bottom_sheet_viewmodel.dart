import 'package:flutter/material.dart';

class OptionSelectionViewModel extends ChangeNotifier {
  final List<String> colorOptions;
  final List<String> sizeOptions;
  final int originalPrice;
  final int discountRate;

  String? selectedColor;
  String? selectedSize;
  int quantity = 1;

  OptionSelectionViewModel({
    required this.colorOptions,
    required this.sizeOptions,
    required this.originalPrice,
    required this.discountRate,
  });

  /// 할인 적용된 단가
  int get discountedPrice {
    final discountAmount = (originalPrice * discountRate / 100).floor();
    return originalPrice - discountAmount;
  }

  /// 총 금액 (단가 × 수량)
  int get totalPrice => discountedPrice * quantity;

  void selectColor(String? color) {
    selectedColor = color;
    notifyListeners();
  }

  void selectSize(String? size) {
    selectedSize = size;
    notifyListeners();
  }

  void increaseQuantity() {
    quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }
}
