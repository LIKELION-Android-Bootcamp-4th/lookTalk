import 'package:dio/dio.dart';
import 'package:look_talk/core/network/api_result.dart';
// [✅ 수정] 알려주신 실제 경로로 수정합니다.
import 'package:look_talk/core/network/end_points/wishlist/wishlist_endpoints.dart';
import 'package:look_talk/model/entity/response/wishlist_response.dart';

class WishlistApiClient {
  final Dio _dio;
  WishlistApiClient(this._dio);

  /// 찜 목록 가져오기
  Future<ApiResult<WishlistResponse>> fetchWishlist({int page = 1}) async {
    print('[WishlistApiClient] API 요청 보냄: GET ${WishlistEndpoints.getWishlist}?page=$page');
    final response = await _dio.get(
      WishlistEndpoints.getWishlist,
      queryParameters: {'page': page, 'limit': 10},
    );
    return ApiResult.fromResponse(
      response,
          (json) => WishlistResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 찜 아이템 추가하기
  Future<ApiResult<void>> addItemToWishlist(String productId) async {
    final response = await _dio.post(
      WishlistEndpoints.addItem,
      data: {'productId': productId},
    );
    return ApiResult.fromVoidResponse(response);
  }

  /// 찜 아이템 삭제하기
  Future<ApiResult<void>> removeItemFromWishlist(String productId) async {
    final response = await _dio.delete('${WishlistEndpoints.removeItemBase}/$productId');
    return ApiResult.fromVoidResponse(response);
  }
}