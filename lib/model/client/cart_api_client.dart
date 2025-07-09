// lib/model/client/cart_api_client.dart

// 'end_points' 뒤에 '/cart' 경로를 추가하여 수정했습니다.
import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/cart/cart_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_result.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';

class CartApiClient {
  final Dio dioClient;

  CartApiClient(this.dioClient);

  /// 장바구니 목록 조회
  Future<ApiResult<CartResponse>> fetchCart() async {
    final response = await dioClient.get(CartEndpoints.getcartList);
    print ('TEST ${response.data}');
    // ApiResult.fromJson의 두 번째 인자는 Object?를 받으므로, 형변환을 명시적으로 해줍니다.
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
    // DioClient의 wrapper 대신, body 전송을 지원하는 원본 dio 인스턴스를 직접 사용합니다.
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
    // 204 No Content는 성공이지만 body가 없으므로, 응답을 직접 파싱하지 않고 성공 결과를 수동으로 생성합니다.
    if (response.statusCode == 204) {
      return ApiResult(
        success: true,
        message: 'Cart cleared successfully.',
        data: null,
        timestamp: DateTime.now(),
      );
    }
    // 204가 아닌 다른 응답 코드(에러 등)는 기존 방식으로 처리합니다.
    return ApiResult.fromVoidResponse(response);
  }
}