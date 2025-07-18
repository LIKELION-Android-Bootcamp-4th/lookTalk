import 'package:dio/dio.dart';
import 'package:look_talk/model/entity/request/create_order_request.dart';
import 'package:look_talk/model/entity/response/order_response.dart';
import 'package:look_talk/core/network/api_result.dart';

class OrderRepository {
  final Dio dio;

  OrderRepository(this.dio);

  /// 주문 생성 - 응답으로 OrderResponse 받음
  Future<ApiResult<OrderResponse>> createOrder(CreateOrderRequest request) async {
    try {
      final response = await dio.post(
        '/api/orders',
        data: request.toJson(),
      );

      return ApiResult.fromResponse(
        response,
            (json) => OrderResponse.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResult(
        success: false,
        message: '주문 요청 실패',
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  /// 주문 목록 조회
  Future<ApiResult<List<OrderResponse>>> fetchOrderList() async {
    try {
      final response = await dio.get('/api/orders');
      return ApiResult.fromResponse(
        response,
            (json) => (json as List)
            .map((e) => OrderResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return ApiResult(
        success: false,
        message: '주문 목록 조회 실패',
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }
}
