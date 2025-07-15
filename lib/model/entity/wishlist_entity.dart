import 'package:look_talk/model/entity/wishlist_dto.dart';

class WishlistItemEntity {
  final String id;
  final String productId;
  final String name;
  final int price;
  final String? thumbnailImageUrl;
  final String? storeName;
  final int? discountRate;

  WishlistItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.thumbnailImageUrl,
    this.storeName,
    this.discountRate,
  });

  factory WishlistItemEntity.fromDto(WishlistItemDto dto) {
    return WishlistItemEntity(
      id: dto.id,
      productId: dto.entity.id,
      name: dto.entity.name,
      price: dto.entity.price,
      thumbnailImageUrl: dto.entity.thumbnailImageUrl,
      storeName: null,
      discountRate: null,
    );
  }
}