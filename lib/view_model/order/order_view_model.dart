// lib/view_model/order/order_view_model.dart

import 'package:flutter/material.dart';
import '../../model/repository/order_repository.dart';
import '../../model/entity/request/create_order_request.dart';
import '../../model/entity/response/order_response.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository repository;

  OrderViewModel(this.repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// 주문 생성 함수
  Future<OrderResponse?> createOrder({
    required List<OrderItemRequest> items,
    required ShippingInfoRequest shippingInfo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final request = CreateOrderRequest(items: items, shippingInfo: shippingInfo);
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
}
