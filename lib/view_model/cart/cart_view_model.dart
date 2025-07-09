// lib/view_model/cart/cart_view_model.dart

import 'package:flutter/material.dart';
import 'dart:collection'; // [✅ HashSet을 사용하기 위해 import]
import '../../model/repository/cart_repository.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';


class CartViewModel extends ChangeNotifier {
  final CartRepository repository;

  // 서버로부터 받은 원본 데이터
  CartResponse? _cart;
  // UI에서 사용하는 데이터 (getters)
  UnmodifiableListView<CartItem> get cartItems => UnmodifiableListView(_cart?.items ?? []);

  // UI 상태 관리
  bool isLoading = false;
  String? error;
  // cart_view_model.dart 파일 내

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
    _selectedItemIds.clear(); // [✅ 목록 새로고침 시 선택 상태 초기화]
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

  /// [✅ 아이템 선택/해제 토글]
  void toggleItemSelection(String itemId, bool isSelected) {
    if (isSelected) {
      _selectedItemIds.add(itemId);
    } else {
      _selectedItemIds.remove(itemId);
    }
    notifyListeners(); // UI 상태가 변경되었으므로 화면에 알림
  }

  /// [✅ 전체 선택/해제 토글]
  void toggleSelectAll(bool isSelected) {
    if (isSelected) {
      _selectedItemIds.addAll(cartItems.map((item) => item.id));
    } else {
      _selectedItemIds.clear();
    }
    notifyListeners();
  }


  /// [✅ 장바구니에서 '선택된' 상품들 삭제]
  Future<void> removeSelectedItems() async {
    if (_selectedItemIds.isEmpty) return; // 선택된 아이템이 없으면 아무것도 안 함

    final result = await repository.removeCartItems(_selectedItemIds.toList());
    if (result.success) {
      await fetchCart(); // 성공 시 장바구니 목록 새로고침
    } else {
      error = result.message;
      notifyListeners();
    }
  }

  /// 장바구니 전체 비우기
  Future<void> clearCart() async {
    // ... 기존 코드 ...
  }

  /// 장바구니에 상품 추가
  Future<void> addCartItem(Map<String, dynamic> payload) async {
    // ... 기존 코드 ...
  }
}