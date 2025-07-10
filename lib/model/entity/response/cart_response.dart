// lib/model/entity/response/cart_response.dart

class CartResponse {
  final List<CartItem> items;
  final CartPagination pagination;

  CartResponse({required this.items, required this.pagination});

  // [✅ 수정된 부분]
  // ApiResult에서 이미 'data' 객체를 넘겨주므로, 여기서는 바로 'items'와 'pagination'을 파싱합니다.
  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: CartPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class CartItem {
  final String id;
  final String companyName;
  final CartProduct product;
  final int quantity;
  final int cartPrice;
  final int totalPrice;

  CartItem({
    required this.id,
    required this.companyName,
    required this.product,
    required this.quantity,
    required this.cartPrice,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '브랜드 없음',
      product: CartProduct.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 0,
      cartPrice: json['cartPrice'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
    );
  }
}

class CartProduct {
  final String id;
  final String name;
  final String? thumbnailImage;
  final Map<String, dynamic> options;
  final String status;
  final Discount? discount;

  CartProduct({
    required this.id,
    required this.name,
    this.thumbnailImage,
    required this.options,
    required this.status,
    this.discount,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      thumbnailImage: json['thumbnailImage'],
      options: json['options'] ?? {},
      status: json['status'] ?? '',
      // 서버에서 discount 필드가 null일 수 있으므로, null 체크 후 파싱
      discount: json['discount'] != null
          ? Discount.fromJson(json['discount'])
          : null,
    );
  }
}

class Discount {
  final String type;
  final int amount;
  final int originalPrice;
  final int discountedPrice;

  Discount({
    required this.type,
    required this.amount,
    required this.originalPrice,
    required this.discountedPrice,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      type: json['type'] ?? '',
      amount: json['amount'] ?? 0,
      originalPrice: json['originalPrice'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
    );
  }
}

class CartPagination {
  final int currentPage;
  final int totalPages;
  final int total;

  CartPagination({
    required this.currentPage,
    required this.totalPages,
    required this.total,
  });

  factory CartPagination.fromJson(Map<String, dynamic> json) {
    return CartPagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      total: json['total'] ?? 0,
    );
  }
}

// 삭제 응답을 위한 클래스 (API 연동 시 필요)
class RemoveCartResult {
  final int removedCount;
  final int remainingItems;

  RemoveCartResult({
    required this.removedCount,
    required this.remainingItems,
  });

  factory RemoveCartResult.fromJson(Map<String, dynamic> json) {
    return RemoveCartResult(
      removedCount: json['removedCount'] ?? 0,
      remainingItems: json['remainingItems'] ?? 0,
    );
  }
}
