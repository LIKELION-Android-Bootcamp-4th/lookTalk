import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/model/client/wishlist_api_client.dart';
import 'package:look_talk/model/entity/response/wishlist_response.dart';

class WishlistRepository {
  final WishlistApiClient _apiClient;

  WishlistRepository(this._apiClient);

  /// 찜 목록 가져오기
  Future<ApiResult<WishlistResponse>> fetchWishlist({int page = 1}) {
    return _apiClient.fetchWishlist(page: page);
  }
  Future<ApiResult<void>> addItem(String productId) {
    return _apiClient.addItemToWishlist(productId);
  }
  /// [✅ 추가] 찜 아이템 삭제
  Future<ApiResult<void>> removeItem(String productId) {
    return _apiClient.removeItemFromWishlist(productId);
  }
}