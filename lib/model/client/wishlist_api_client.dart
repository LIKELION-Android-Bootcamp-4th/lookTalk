import 'package:dio/dio.dart';
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/core/network/end_points/wishlist/wishlist_endpoints.dart';
import 'package:look_talk/model/entity/wishlist_dto.dart';

class WishlistApiClient {
  final Dio _dio;
  WishlistApiClient(this._dio);

  Future<ApiResult<WishlistResponseDto>> fetchWishlist({int page = 1}) async {
    try {
      final response = await _dio.get(
        WishlistEndpoints.getWishlist,
        queryParameters: {'page': page, 'limit': 10},
      );
      return ApiResult.fromResponse(response,
              (json) => WishlistResponseDto.fromJson(json as Map<String, dynamic>));
    } on DioException catch (e) {
      return ApiResult(
          success: false, message: e.message ?? '찜 목록 로드 실패',
          data: null, timestamp: DateTime.now(), error: e.toString());
    } catch (e) {
      return ApiResult(
          success: false, message: '알 수 없는 오류 발생',
          data: null, timestamp: DateTime.now(), error: e.toString());
    }
  }

  Future<ApiResult<void>> toggleFavorite(String productId) async {
    try {
      final response = await _dio.post(
        '${WishlistEndpoints.toggleFavorites}/$productId/toggle-favorites',
      );
      return ApiResult.fromVoidResponse(response);
    } on DioException catch (e) {
      return ApiResult(
          success: false, message: e.message ?? '찜 처리 중 오류 발생',
          data: null, timestamp: DateTime.now(), error: e.toString());
    } catch (e) {
      return ApiResult(
          success: false, message: '알 수 없는 오류 발생',
          data: null, timestamp: DateTime.now(), error: e.toString());
    }
  }
}