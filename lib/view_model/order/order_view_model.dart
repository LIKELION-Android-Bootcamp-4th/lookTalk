// lib/view_model/order/order_view_model.dart

import 'package:flutter/material.dart';
// [수정] 각 파일을 별칭(prefix)으로 가져옵니다.
import 'package:look_talk/model/entity/request/checkout_request.dart' as checkout;
import 'package:look_talk/model/entity/request/create_order_request.dart' as create_order;
import '../../model/repository/order_repository.dart';
import '../../model/entity/response/order_response.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository repository;

  OrderViewModel(this.repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // ===================================================================
  // [기존 방식] 다른 팀원이 사용하는 주문 생성 함수
  // ===================================================================
  Future<OrderResponse?> createOrder({
    required String cartId,
    required List<create_order.OrderItemRequest> items,
    // [핵심 수정] create_order 별칭을 사용해 타입을 명확히 지정합니다.
    required create_order.ShippingInfoRequest shippingInfo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final request = create_order.CreateOrderRequest(cartId: cartId, items: items, shippingInfo: shippingInfo);
    final result = await repository.createOrder(request);

    OrderResponse? orderResponse;
    if (result.success && result.data != null) {
      orderResponse = result.data;
    } else {
      _error = result.message;
    }

    _isLoading = false;
    notifyListeners();
    return orderResponse;
  }

  // ===================================================================
  // [새로운 방식] /api/cart/checkout API를 위한 함수
  // ===================================================================
  Future<OrderResponse?> checkoutFromCart({
    required String cartId,
    // [핵심 수정] checkout 별칭을 사용해 타입을 명확히 지정합니다.
    required checkout.ShippingInfoRequest shippingInfo,
    String? memo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final request = checkout.CheckoutRequest(
      cartIds: [cartId],
      shippingInfo: shippingInfo,
      memo: memo,
    );

    final result = await repository.checkout(request);

    OrderResponse? orderResponse;
    if (result.success && result.data != null) {
      orderResponse = result.data;
    } else {
      _error = result.message;
    }

    _isLoading = false;
    notifyListeners();
    return orderResponse;
  }
}