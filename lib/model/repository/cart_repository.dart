// cart_repository.dart

import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/model/client/cart_api_client.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';
import 'package:look_talk/model/entity/response/checkout_response.dart';

class CartRepository {
  final CartApiClient _apiClient;
  CartRepository(this._apiClient);

  Future<ApiResult<CartResponse>> fetchCart() {
    return _apiClient.fetchCart();
  }

  Future<ApiResult<CartItem>> addCartItem({
    required String productId,
    required int unitPrice,
    required int quantity,
  }) {
    // 수정된 ApiClient 함수를 직접 호출하며,
    // 올바른 파라미터 'unitPrice'를 전달합니다.
    return _apiClient.addCartItem(
      productId: productId,
      unitPrice: unitPrice,
      quantity: quantity,
    );
  }

  Future<ApiResult<RemoveCartResult>> removeCartItems(List<String> cartIds) {
    return _apiClient.removeCartItems(cartIds);
  }

  Future<ApiResult<void>> clearCart() {
    return _apiClient.clearCart();
  }

  Future<ApiResult<CheckoutResponse>> checkout(List<String> cartIds) {
    return _apiClient.checkout(cartIds);
  }
}