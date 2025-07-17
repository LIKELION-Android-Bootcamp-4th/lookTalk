import 'package:flutter/material.dart';
import 'dart:collection';
import '../../model/entity/request/create_order_request.dart';
import '../../model/entity/response/checkout_response.dart';
import '../../model/repository/cart_repository.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';
import '../../core/network/api_result.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository repository;

  CartResponse? _cart;
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

  void toggleItemSelection(String itemId, bool isSelected) {
    if (isSelected) {
      _selectedItemIds.add(itemId);
    } else {
      _selectedItemIds.remove(itemId);
    }
    notifyListeners();
  }

  void toggleSelectAll(bool isSelected) {
    if (isSelected) {
      _selectedItemIds.addAll(
        cartItems.map((item) => item.id).whereType<String>(),
      );
    } else {
      _selectedItemIds.clear();
    }
    notifyListeners();
  }

  Future<void> removeSelectedItems() async {
    if (_selectedItemIds.isEmpty) return;

    final result = await repository.removeCartItems(_selectedItemIds.toList());
    if (result.success) {
      await fetchCart();
    } else {
      error = result.message;
      notifyListeners();
    }
  }

  /// ✅ 장바구니에 상품 추가 (단가 + 옵션 포함)
  // Future<ApiResult<CartItem>> addCartItem({
  //   required String productId,
  //   required String color,
  //   required String size,
  //   required int unitPrice,
  //   required int quantity,
  // }) async {
  //   final result = await repository.addCartItem(
  //     productId: productId,
  //     unitPrice: unitPrice,
  //     quantity: quantity,
  //     color: color,
  //     size: size,
  //   );
  //
  //   if (result.success) {
  //     await fetchCart();
  //   } else {
  //     error = result.message;
  //     notifyListeners();
  //   }
  //
  //   return result;
  // }

  Future<bool> addCartItem({
    required String productId,
    required int unitPrice,
    required int quantity,
    required String color,
    required String size,
    int? discountPercent,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await repository.addCartItem(
      productId: productId,
      unitPrice: unitPrice,
      quantity: quantity,
      color: color,
      size: size,
      discountPercent: discountPercent,
    );

    if (result.success) {
      print('장바구니 넣기 성공');
      return true;
    } else {
      error = result.message ?? '장바구니 추가 중 오류가 발생했어요.';
      return false;
    }

    isLoading = false;
    notifyListeners();
  }




  Future<void> clearCart() async {
    final result = await repository.clearCart();
    if (result.success) {
      _cart?.items.clear();
      _selectedItemIds.clear();
      error = null;
    } else {
      error = result.message;
    }
    notifyListeners();
  }
  Future<CheckoutResponse?> creatOrder({
    required List<CartItem> cartItems,
    required ShippingInfoRequest info,

  }) async {
    isLoading=true;
    final cartIds = cartItems.map((e) => e.id!).toList();
    final result = await repository.checkout(cartIds, info);
    if (result.success) {
      return result.data;
    }else {
      error=result.message;
    }
  }
}
