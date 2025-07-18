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

  List<OrderResponse> _orderList = [];
  List<OrderResponse> get orderList => _orderList;

  /// 주문 생성
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
    if (result.success && result.data != null && result.data is OrderResponse) {
      orderResponse = result.data as OrderResponse;
      await fetchOrderList();
    } else {
      _error = result.message;
    }

    _isLoading = false;
    notifyListeners();
    return orderResponse;
  }

  /// 주문 목록 조회
  Future<void> fetchOrderList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await repository.fetchOrderList();

    if (result.success && result.data != null && result.data is List<OrderResponse>) {
      _orderList = result.data as List<OrderResponse>;
    } else {
      _error = result.message;
    }

    _isLoading = false;
    notifyListeners();
  }
}
