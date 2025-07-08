// lib/model/repository/cart_repository.dart

import '../client/cart_api_client.dart';
import '../../core/network/api_result.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';

class CartRepository {
  final CartApiClient apiClient;
  CartRepository(this.apiClient);

  /// 장바구니 목록 조회
  Future<ApiResult<CartResponse>> fetchCart() => apiClient.fetchCart();

  /// 장바구니 상품 추가
  Future<ApiResult<CartItem>> addCartItem(Map<String, dynamic> payload) =>
      apiClient.addCartItem(payload);

  /// 장바구니 선택 상품 삭제
  /// API 클라이언트의 함수 이름(removeCartItems)과 파라미터 타입(List<String>)에 맞게 수정
  Future<ApiResult<RemoveCartResult>> removeCartItems(List<String> cartIds) =>
      apiClient.removeCartItems(cartIds);

  /// 장바구니 전체 삭제 기능 추가
  Future<ApiResult<void>> clearCart() => apiClient.clearCart();
}