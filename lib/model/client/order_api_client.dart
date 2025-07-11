// lib/model/client/order_api_client.dart

import '../../core/network/dio_client.dart';
import '../../core/network/api_result.dart';
import '../entity/request/create_order_request.dart';
import '../entity/response/order_response.dart';

class OrderApiClient {
  final DioClient dioClient;

  OrderApiClient(this.dioClient);

  /// 주문 생성
  Future<ApiResult<OrderResponse>> createOrder(CreateOrderRequest request) async {
    final response = await dioClient.post(
      '/api/orders',
      data: request.toJson(),
    );
    return ApiResult.fromResponse(
        response, (json) => OrderResponse.fromJson(json as Map<String, dynamic>));
  }
}
