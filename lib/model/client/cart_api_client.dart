import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/cart/cart_endpoints.dart';
import 'package:look_talk/model/entity/request/create_order_request.dart';
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

  /// ✅ 옵션 포함 요청
  Future<ApiResult<CartItem>> addCartItem({
    required String productId,
    required int unitPrice,
    required int quantity,
    required String color,
    required String size,
    int? discountPercent,
  }) async {
    final payload = {
      'productId': productId,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'options': {
        'color': color,
        'size': size,
      },
    };

    if(discountPercent != null){
      payload['discount'] = {
        'type': 'percent',
        'amount': discountPercent,
      };
    }

    final response = await _dio.post(CartEndpoints.addCartItem, data: payload);
    return ApiResult.fromResponse(
        response, (json) => CartItem.fromJson(json as Map<String, dynamic>));
  }

  Future<ApiResult<RemoveCartResult>> removeCartItems(List<String> cartIds) async {
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

  Future<ApiResult<CheckoutResponse>> checkout(List<String>? cartIds , ShippingInfoRequest info) async {
    final Map<String, dynamic> data = {
      'shippingInfo': info,
      if (cartIds != null) 'cartIds': cartIds,
    };

    final response = await _dio.post(
      CartEndpoints.cartCheckOut,
      data: data,
    );
    return ApiResult.fromResponse(
        response, (json) => CheckoutResponse.fromJson(json as Map<String, dynamic>));
  }
}
