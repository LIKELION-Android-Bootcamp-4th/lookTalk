import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/wishlist/wishlist_endpoints.dart';
import 'package:look_talk/model/entity/wishlist_dto.dart'; // DTO 파일 경로 확인 필요

class WishlistRepository {
  final Dio _dio;
  WishlistRepository(this._dio);

  // ApiResult 대신 DTO를 직접 반환하고, 실패 시 Exception을 던집니다.
  Future<WishlistResponseDto> fetchWishlist({int page = 1}) async {
    try {
      final response = await _dio.get(
        WishlistEndpoints.getWishlist,
        queryParameters: {'page': page, 'limit': 10},
      );
      // 서버 응답의 data 필드 안에 실제 데이터가 있으므로, response.data['data']를 넘겨줍니다.
      return WishlistResponseDto.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('찜 목록을 불러오는데 실패했습니다: $e');
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      await _dio.post(
        '${WishlistEndpoints.toggleFavorites}/$productId/toggle-favorites',
      );
    } catch (e) {
      throw Exception('찜 처리 중 오류가 발생했습니다: $e');
    }
  }
}