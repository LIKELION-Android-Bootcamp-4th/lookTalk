import 'package:flutter/material.dart';

class OptionSelectionViewModel extends ChangeNotifier {
  List<String> colorOptions = ['검정색', '흰색'];
  List<String> sizeOptions = ['S', 'M', 'L'];
  int discountedPrice = 10000;

  String? selectedColor;
  String? selectedSize;
  int quantity = 1;

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
