// lib/view_model/cart/cart_view_model.dart

import 'package:flutter/material.dart';
import '../../model/repository/cart_repository.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository repository;
  CartResponse? cart;
  bool isLoading = false;
  String? error;

  CartViewModel(this.repository);

  /// 장바구니 목록 불러오기
  Future<void> fetchCart() async {
    isLoading = true;
    notifyListeners();

    final result = await repository.fetchCart();
    if (result.success) {
      cart = result.data;
      error = null;
    } else {
      error = result.message;
    }
    isLoading = false;
    notifyListeners();
  }

  /// 장바구니에 상품 추가
  Future<void> addCartItem(Map<String, dynamic> payload) async {
    final result = await repository.addCartItem(payload);
    if (result.success) {
      await fetchCart(); // 성공 시 장바구니 목록 새로고침
    } else {
      error = result.message;
      notifyListeners();
    }
  }

  /// 장바구니에서 여러 상품 삭제
  Future<void> removeCartItems(List<String> cartIds) async {
    final result = await repository.removeCartItems(cartIds);
    if (result.success) {
      await fetchCart(); // 성공 시 장바구니 목록 새로고침
    } else {
      error = result.message;
      notifyListeners();
    }
  }

  /// 장바구니 전체 비우기
  Future<void> clearCart() async {
    final result = await repository.clearCart();
    if (result.success) {
      await fetchCart(); // 성공 시 장바구니 목록 새로고침
    } else {
      error = result.message;
      notifyListeners();
    }
  }
}