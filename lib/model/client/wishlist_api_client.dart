import 'package:dio/dio.dart'; // [✅ 수정]
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/core/network/end_points/wishlist/wishlist_endpoints.dart';
import 'package:look_talk/model/entity/response/wishlist_response.dart';

class WishlistApiClient {
  final Dio _dio; // [✅ 수정] DioClient -> Dio
  WishlistApiClient(this._dio); // [✅ 수정] DioClient -> Dio

  /// 찜 목록 가져오기
  Future<ApiResult<WishlistResponse>> fetchWishlist({int page = 1}) async {
    print('[WishlistApiClient] API 요청 보냄: GET ${WishlistEndpoints.getWishlist}?page=$page');
    final response = await _dio.get( // [✅ 수정] _dioClient -> _dio
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
    final response = await _dio.post( // [✅ 수정]
      WishlistEndpoints.addItem,
      data: {'productId': productId},
    );
    return ApiResult.fromVoidResponse(response);
  }

  /// 찜 아이템 삭제하기
  Future<ApiResult<void>> removeItemFromWishlist(String productId) async {
    final response = await _dio.delete('${WishlistEndpoints.removeItemBase}/$productId'); // [✅ 수정]
    return ApiResult.fromVoidResponse(response);
  }
}