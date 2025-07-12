// lib/model/repository/order_repository.dart

import '../client/order_api_client.dart';
import '../../core/network/api_result.dart';
import '../entity/request/create_order_request.dart';
import '../entity/response/order_response.dart';

class OrderRepository {
  final OrderApiClient apiClient;

  OrderRepository(this.apiClient);

  /// 주문 생성
  Future<ApiResult<OrderResponse>> createOrder(CreateOrderRequest request) =>
      apiClient.createOrder(request);
}
