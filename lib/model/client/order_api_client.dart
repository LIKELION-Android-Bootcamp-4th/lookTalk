import 'package:dio/dio.dart'; // [✅ 수정] Dio를 직접 사용하기 위해 임포트
import '../../core/network/api_result.dart';
import '../entity/request/create_order_request.dart';
import '../entity/response/order_response.dart';

class OrderApiClient {
  // [✅ 수정] DioClient 대신 Dio 객체를 직접 받습니다.
  final Dio _dio;

  OrderApiClient(this._dio);

  /// 주문 생성
  Future<ApiResult<OrderResponse>> createOrder(CreateOrderRequest request) async {
    // [✅ 수정] _dioClient.post -> _dio.post
    final response = await _dio.post(
      '/api/orders',
      data: request.toJson(),
    );
    return ApiResult.fromResponse(
        response, (json) => OrderResponse.fromJson(json as Map<String, dynamic>));
  }
}