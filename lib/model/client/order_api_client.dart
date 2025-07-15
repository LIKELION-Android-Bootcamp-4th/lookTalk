import 'package:dio/dio.dart'; // [✅ 수정] Dio를 직접 사용하기 위해 임포트
import 'package:look_talk/core/network/end_points/cart/cart_endpoints.dart';
import '../../core/network/api_result.dart';
import '../entity/request/checkout_request.dart';
import '../entity/request/create_order_request.dart';
import '../entity/response/order_response.dart';


class OrderApiClient {
  final Dio _dio;

  OrderApiClient(this._dio);

  /// 주문 생성
  Future<ApiResult<OrderResponse>> createOrder(CreateOrderRequest request) async {
    // [✅ 핵심 수정] API 호출 주소를 '/api/orders' 대신,
    // CartEndpoints에 정의된 cartCheckOut, 즉 '/api/cart/checkout'으로 변경합니다.
    final response = await _dio.post(
      CartEndpoints.cartCheckOut,
      data: request.toJson(),
    );
    // [참고] 서버 응답이 OrderResponse와 호환되지 않을 경우,
    // 이 부분에서 에러가 발생할 수 있습니다.
    // 현재는 기존 구조를 유지합니다.
    return ApiResult.fromResponse(
        response, (json) => OrderResponse.fromJson(json as Map<String, dynamic>));
  }

  Future<ApiResult<OrderResponse>> checkout(CheckoutRequest request) async {
    final response = await _dio.post(
      CartEndpoints.cartCheckOut, // '/api/cart/checkout'
      data: request.toJson(),
    );
    return ApiResult.fromResponse(
        response, (json) =>
        OrderResponse.fromJson(json as Map<String, dynamic>));

  }
}