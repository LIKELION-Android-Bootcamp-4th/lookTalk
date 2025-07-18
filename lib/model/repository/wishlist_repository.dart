import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/wishlist/wishlist_endpoints.dart';
import 'package:look_talk/model/entity/wishlist_dto.dart';

class WishlistRepository {
  final Dio _dio;
  WishlistRepository(this._dio);

  /// 찜 목록 조회
  Future<WishlistResponseDto> fetchWishlist({int page = 1}) async {
    try {
      final response = await _dio.get(
        WishlistEndpoints.getWishlist,
        queryParameters: {'page': page, 'limit': 10},
      );
      return WishlistResponseDto.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('찜 목록을 불러오는데 실패했습니다: $e');
    }
  }

  /// ✅ 특정 상품 찜 여부 확인
  Future<bool> checkFavorite(String productId) async {
    try {
      final response = await _dio.get(
        '/api/products/$productId/favorites',
      );
      return response.data['data']['isFavorite'] ?? false;
    } catch (e) {
      throw Exception('찜 여부 확인에 실패했습니다: $e');
    }
  }

  /// ✅ 찜 토글 (추가/삭제)
  Future<void> toggleFavorite(String productId) async {
    try {
      await _dio.post(
        '/api/products/$productId/toggle-favorites',
      );
    } catch (e) {
      throw Exception('찜 상태 변경 중 오류가 발생했습니다: $e');
    }
  }

  /// ❌ [주의] 이건 이제 removeItem이 아니라 toggleFavorite으로 통합 가능
  @deprecated
  Future<void> removeItem(String productId) async {
    return toggleFavorite(productId); // 실질적 동일 동작
  }
}
