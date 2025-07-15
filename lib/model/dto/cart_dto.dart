// lib/model/dto/cart_dto.dart

// [설명] 장바구니 관련 서버 응답을 그대로 담기 위한 DTO(Data Transfer Object) 클래스들입니다.

class CartResponseDto {
  final List<CartItemDto> items;
  final PaginationDto? pagination;

  CartResponseDto({required this.items, this.pagination});

  factory CartResponseDto.fromJson(Map<String, dynamic> json) {
    return CartResponseDto(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => CartItemDto.fromJson(item))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationDto.fromJson(json['pagination'])
          : null,
    );
  }
}

class CartItemDto {
  final String? id;
  final int? quantity;
  final int? cartPrice;
  final int? totalPrice;
  // [설명] 장바구니의 상품 정보는 별도의 ProductInCartDto로 받습니다.
  final ProductInCartDto? product;

  CartItemDto({
    this.id,
    this.quantity,
    this.cartPrice,
    this.totalPrice,
    this.product,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) {
    return CartItemDto(
      id: json['id'],
      quantity: json['quantity'],
      cartPrice: json['cartPrice'],
      totalPrice: json['totalPrice'],
      product: json['product'] != null ? ProductInCartDto.fromJson(json['product']) : null,
    );
  }
}

// [설명] 장바구니 목록 API에 포함된 상품 정보만을 위한 DTO입니다.
class ProductInCartDto {
  final String? id;
  final String? name;
  final int? price;
  final String? thumbnailImageUrl;
  final StoreInCartDto? store;
  final DiscountInCartDto? discount;
  final bool? isFavorite;

  ProductInCartDto({
    this.id, this.name, this.price, this.thumbnailImageUrl,
    this.store, this.discount, this.isFavorite,
  });

  factory ProductInCartDto.fromJson(Map<String, dynamic> json) {
    return ProductInCartDto(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      thumbnailImageUrl: json['thumbnailImageUrl'],
      store: json['store'] != null ? StoreInCartDto.fromJson(json['store']) : null,
      discount: json['discount'] != null ? DiscountInCartDto.fromJson(json['discount']) : null,
      isFavorite: json['isFavorite'],
    );
  }
}

class StoreInCartDto {
  final String? id;
  final String? name;
  StoreInCartDto({this.id, this.name});
  factory StoreInCartDto.fromJson(Map<String, dynamic> json) {
    return StoreInCartDto(id: json['id'], name: json['name']);
  }
}

class DiscountInCartDto {
  final String? type;
  final int? value;
  DiscountInCartDto({this.type, this.value});
  factory DiscountInCartDto.fromJson(Map<String, dynamic> json) {
    return DiscountInCartDto(type: json['type'], value: json['value']);
  }
}

class PaginationDto {
  final int? currentPage;
  final int? totalPages;
  final int? total;
  final bool? hasNext;
  PaginationDto({this.currentPage, this.totalPages, this.total, this.hasNext});
  factory PaginationDto.fromJson(Map<String, dynamic> json) {
    return PaginationDto(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      total: json['total'],
      hasNext: json['hasNext'],
    );
  }
}