// cart_api_client.dart

import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/cart/cart_endpoints.dart';
import '../../core/network/api_result.dart';
import '../entity/response/cart_response.dart';
import '../entity/response/checkout_response.dart';

class CartApiClient {
  final Dio _dio;

  CartApiClient(this._dio);

  Future<ApiResult<CartResponse>> fetchCart() async {
    final response = await _dio.get(CartEndpoints.getcartList);
    return ApiResult.fromResponse(
        response, (json) => CartResponse.fromJson(json as Map<String, dynamic>));
  }

  Future<ApiResult<CartItem>> addCartItem({
    required String productId,
    required int unitPrice,
    required int quantity,
  }) async {
    final payload = {
      'productId': productId,
      'unitPrice': unitPrice,
      'quantity': quantity,
    };
    final response = await _dio.post(CartEndpoints.getcartList, data: payload);
    return ApiResult.fromResponse(
        response, (json) => CartItem.fromJson(json as Map<String, dynamic>));
  }

  Future<ApiResult<RemoveCartResult>> removeCartItems(
      List<String> cartIds) async {
    final response = await _dio.delete(
      CartEndpoints.cartDelete,
      data: {"cartIds": cartIds},
    );
    return ApiResult.fromResponse(
        response, (json) => RemoveCartResult.fromJson(json as Map<String, dynamic>));
  }

  Future<ApiResult<void>> clearCart() async {
    final response = await _dio.delete(CartEndpoints.cartDeleteAll);
    return ApiResult.fromVoidResponse(response);
  }

  Future<ApiResult<CheckoutResponse>> checkout(List<String> cartIds) async {
    final response = await _dio.post(
      CartEndpoints.cartCheckOut,
      data: {"cartIds": cartIds},
    );
    return ApiResult.fromResponse(
        response, (json) => CheckoutResponse.fromJson(json as Map<String, dynamic>));
  }
}