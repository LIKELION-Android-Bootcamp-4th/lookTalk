// lib/model/entity/response/wishlist_response.dart

import 'package:look_talk/model/entity/response/pagination_entity.dart';

class WishlistResponse {
  final List<WishlistItem> items;
  final Pagination pagination;

  WishlistResponse({
    required this.items,
    required this.pagination,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final paginationData = data['pagination'] as Map<String, dynamic>? ?? {};

    return WishlistResponse(
      items: (data['items'] as List<dynamic>? ?? [])
          .map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(paginationData),
    );
  }
}

// [수정] 서버 응답에 실제로 있는 데이터만 파싱하도록 수정
class WishlistItem {
  final String id;
  final String productId;
  final String name;
  final int price;
  final String? thumbnailImageUrl;
  // [수정] 서버에서 오지 않으므로, 임시로 기본값을 갖도록 처리
  final String storeName;
  final int? discountRate;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.thumbnailImageUrl,
    // [수정] required 제거하고 기본값 할당
    this.storeName = '상점 정보 없음',
    this.discountRate,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    // 상품 정보는 'entity' 객체 안에 들어있습니다.
    final entity = json['entity'] as Map<String, dynamic>? ?? {};

    return WishlistItem(
      id: json['id'] ?? '',
      productId: entity['id'] ?? '',
      name: entity['name'] ?? '상품 정보 없음',
      price: entity['price'] ?? 0,
      thumbnailImageUrl: entity['thumbnailImageUrl'],
      // storeName과 discountRate 파싱 로직을 제거했습니다.
      // 어차피 데이터가 없기 때문입니다.
    );
  }
}