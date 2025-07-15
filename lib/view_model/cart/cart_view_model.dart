// lib/view_model/cart/cart_view_model.dart

import 'package:flutter/material.dart';
import 'dart:collection';
import '../../model/entity/response/checkout_response.dart';
import '../../model/repository/cart_repository.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository repository;

  CartResponse? _cart;
  String? get cartId => _cart?.id;
  UnmodifiableListView<CartItem> get cartItems => UnmodifiableListView(_cart?.items ?? []);

  bool isLoading = false;
  String? error;

  final Set<String> _selectedItemIds = HashSet<String>();

  Set<String> get selectedItemIds => Set.unmodifiable(_selectedItemIds);

  int get totalSelectedPrice {
    if (_cart == null) return 0;
    return _cart!.items
        .where((item) => _selectedItemIds.contains(item.id))
        .fold(0, (sum, item) => sum + item.totalPrice);
  }

  bool get isAllSelected => cartItems.isNotEmpty && _selectedItemIds.length == cartItems.length;

  CartViewModel(this.repository);

  /// 장바구니 목록 불러오기
  Future<void> fetchCart() async {
    isLoading = true;
    _selectedItemIds.clear();
    notifyListeners();

    final result = await repository.fetchCart();
    if (result.success) {
      _cart = result.data;
      error = null;
    } else {
      error = result.message;
    }
    isLoading = false;
    notifyListeners();
  }

  /// 아이템 선택/해제 토글
  void toggleItemSelection(String itemId, bool isSelected) {
    if (isSelected) {
      _selectedItemIds.add(itemId);
    } else {
      _selectedItemIds.remove(itemId);
    }
    notifyListeners();
  }

  /// 전체 선택/해제 토글
  void toggleSelectAll(bool isSelected) {
    if (isSelected) {
      _selectedItemIds.addAll(cartItems.map((item) => item.id));
    } else {
      _selectedItemIds.clear();
    }
    notifyListeners();
  }

  /// 선택된 상품들 삭제
  Future<void> removeSelectedItems() async {
    if (_selectedItemIds.isEmpty) return;

    final result = await repository.removeCartItems(_selectedItemIds.toList());
    if (result.success) {
      // 삭제 성공 시, 장바구니 목록을 다시 불러와 UI를 갱신합니다.
      await fetchCart();
    } else {
      error = result.message;
      notifyListeners();
    }
  }

  /// 장바구니에 상품 추가
  Future<void> addItem({required String productId, required int unitPrice, int quantity = 1}) async {
    final result = await repository.addCartItem(
        productId: productId,
        unitPrice: unitPrice,
        quantity: quantity
    );

    if (result.success) {
      // 추가 성공 시, 장바구니 목록을 다시 불러와 UI를 갱신합니다.
      await fetchCart();
    } else {
      error = result.message;
      notifyListeners();
    }
  }

  /// 장바구니 전체 비우기
  Future<void> clearCart() async {
    final result = await repository.clearCart();
    if (result.success) {
      // 성공 시, 로컬 데이터도 즉시 비워 UI에 빠르게 반영합니다.
      _cart?.items.clear();
      _selectedItemIds.clear();
      error = null;
    } else {
      error = result.message;
    }
    notifyListeners();
  }

  /// 선택된 상품 결제 요청 (주문 전 단계)
  Future<CheckoutResponse?> checkout() async {
    if (selectedItemIds.isEmpty) {
      error = '결제할 상품을 선택해주세요.';
      notifyListeners();
      return null;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    final result = await repository.checkout(selectedItemIds.toList());

    isLoading = false;
    if (result.success) {
      notifyListeners();
      return result.data;
    } else {
      error = result.message;
      notifyListeners();
      return null;
    }
  }
}