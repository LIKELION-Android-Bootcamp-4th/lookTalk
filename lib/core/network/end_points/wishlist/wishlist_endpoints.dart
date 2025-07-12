// lib/core/network/end_points/wishlist/wishlist_endpoints.dart

class WishlistEndpoints {
  // [✅ 수정] 실제 서버 경로로 변경
  static const String getWishlist = '/api/mypage/favorites';

  // TODO: 찜 추가/삭제 API 경로도 실제 경로로 수정해야 합니다.
  static const String addItem = '/api/products';
  static const String removeItemBase = '/api/products';
  static const String toggleFavorites = '/api/products';
}