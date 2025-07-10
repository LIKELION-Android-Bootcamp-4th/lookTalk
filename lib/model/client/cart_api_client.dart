// lib/model/client/cart_api_client.dart

import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/cart/cart_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_result.dart';
import '../entity/response/cart_response.dart';
import '../entity/response/checkout_response.dart';

class CartApiClient {
  final Dio dioClient;

  CartApiClient(this.dioClient);

  /// 장바구니 목록 조회
  Future<ApiResult<CartResponse>> fetchCart() async {
    final response = await dioClient.get(CartEndpoints.getcartList);
    return ApiResult.fromResponse(
        response, (json) => CartResponse.fromJson(json as Map<String, dynamic>));
  }

  /// 장바구니에 상품 추가 (POST)
  Future<ApiResult<CartItem>> addCartItem(Map<String, dynamic> payload) async {
    final response = await dioClient.post(CartEndpoints.getcartList, data: payload);
    return ApiResult.fromResponse(
        response, (json) => CartItem.fromJson(json as Map<String, dynamic>));
  }

  /// 장바구니에서 선택된 상품들 삭제 (DELETE with Body)
  Future<ApiResult<RemoveCartResult>> removeCartItems(List<String> cartIds) async {
    final response = await DioClient.instance.delete(
      CartEndpoints.cartDelete,
      data: {"cartIds": cartIds},
    );
    return ApiResult.fromResponse(
        response, (json) => RemoveCartResult.fromJson(json as Map<String, dynamic>));
  }

  /// 장바구니 전체 삭제 (Clear Cart)
  Future<ApiResult<void>> clearCart() async {
    final response = await dioClient.delete(CartEndpoints.cartDeleteAll);
    if (response.statusCode == 204) {
      return ApiResult(
        success: true,
        message: 'Cart cleared successfully.',
        data: null,
        timestamp: DateTime.now(),
      );
    }
    return ApiResult.fromVoidResponse(response);
  }

  /// [✅ 수정] 장바구니 상품으로 주문 생성 (체크아웃)
  Future<ApiResult<CheckoutResponse>> checkout(List<String> cartIds) async {
    final response = await dioClient.post(
      CartEndpoints.cartCheckOut,
      data: {"cartIds": cartIds},
    );
    return ApiResult.fromResponse(
        response, (json) => CheckoutResponse.fromJson(json as Map<String, dynamic>));
  }
}
