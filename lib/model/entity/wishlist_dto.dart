class WishlistResponseDto {
  final List<WishlistItemDto> items;

  WishlistResponseDto({required this.items});

  factory WishlistResponseDto.fromJson(Map<String, dynamic> json) {
    return WishlistResponseDto(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => WishlistItemDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WishlistItemDto {
  final String id;
  final ProductEntityDto entity;

  WishlistItemDto({required this.id, required this.entity});

  factory WishlistItemDto.fromJson(Map<String, dynamic> json) {
    return WishlistItemDto(
      id: json['id'] ?? '',
      entity: ProductEntityDto.fromJson(json['entity'] ?? {}),
    );
  }
}

class ProductEntityDto {
  final String id;
  final String name;
  final int price;
  final String? thumbnailImageUrl;

  ProductEntityDto({required this.id, required this.name, required this.price, this.thumbnailImageUrl});

  factory ProductEntityDto.fromJson(Map<String, dynamic> json) {
    return ProductEntityDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '이름 없음',
      price: json['price'] ?? 0,
      thumbnailImageUrl: json['thumbnailImageUrl'],
    );
  }
}