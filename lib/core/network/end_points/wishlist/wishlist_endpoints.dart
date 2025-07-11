


class WishlistEndpoints {
  // 찜 목록 가져오기 (GET)
  static const String getWishlist = '/api/wishlist';

  // 찜 아이템 추가 (POST)
  static const String addItem = '/api/wishlist';

  // 찜 아이템 삭제 (DELETE)
  // 실제 호출 시에는 '/api/wishlist/{productId}' 형태로 사용됩니다.
  static const String removeItemBase = '/api/wishlist';
}