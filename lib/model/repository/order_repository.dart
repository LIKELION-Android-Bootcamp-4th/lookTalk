// lib/model/repository/order_repository.dart (예상 경로)

import '../../core/network/api_result.dart';
import '../client/order_api_client.dart';
import '../entity/request/checkout_request.dart';
import '../entity/request/create_order_request.dart';
import '../entity/response/order_response.dart';

class OrderRepository {
  final OrderApiClient _apiClient;
  OrderRepository(this._apiClient);

  // 기존 createOrder 함수
  Future<ApiResult<OrderResponse>> createOrder(CreateOrderRequest request) {
    return _apiClient.createOrder(request);
  }

  // [추가] checkout 함수
  Future<ApiResult<OrderResponse>> checkout(CheckoutRequest request) {
    return _apiClient.checkout(request);
  }
}