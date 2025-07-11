import 'dart:convert';
import 'dart:convert';
import 'pagination_entity.dart'; // [✅ 수정]
import 'discount_dto.dart';      // [✅ 수정]


/// 찜 목록 API 응답 전체 모델
class WishlistResponse {
  final List<WishlistItem> items;
  final Pagination pagination;

  WishlistResponse({
    required this.items,
    required this.pagination,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return WishlistResponse(
      items: (data['items'] as List<dynamic>? ?? [])
          .map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(data['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }
}

/// 찜 목록 개별 아이템 모델 (ProductSearch 구조 참고)
class WishlistItem {
  final String id;
  final String name;
  final String? thumbnailImage;
  final String? brandName; // storeName을 brandName으로 사용
  final int price;
  final DiscountDto? discount;

  WishlistItem({
    required this.id,
    required this.name,
    required this.thumbnailImage,
    required this.brandName,
    required this.price,
    this.discount,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    DiscountDto? discount;
    final rawDiscount = json['discount'];

    if (rawDiscount != null && rawDiscount is String && rawDiscount.isNotEmpty) {
      try {
        discount = DiscountDto.fromjson(jsonDecode(rawDiscount));
      } catch (e) {
        discount = null;
      }
    }

    return WishlistItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '상품 정보 없음',
      thumbnailImage: json['thumbnailImageUrl'] ??
          (json['thumbnailImage'] is Map && json['thumbnailImage']?['url'] != null
              ? json['thumbnailImage']['url'].toString()
              : null),
      brandName: json['store']?['name'], // store.name을 brandName으로 사용
      price: json['price'] ?? 0,
      discount: discount,
    );
  }
}