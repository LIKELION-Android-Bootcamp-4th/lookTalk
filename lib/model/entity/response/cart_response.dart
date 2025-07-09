// lib/model/entity/response/cart_response.dart

class CartResponse {
  final bool success;
  final String message;
  final List<CartItem> items;
  final CartPagination pagination;

  CartResponse({
    required this.success,
    required this.message,
    required this.items,
    required this.pagination,
  });

  // 'data' 필드를 직접 처리하는 로직 제거
  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    print('TEST items ${data['items']}');
    return CartResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      items: (data['items'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromJson(e))
          .toList(),
      pagination: CartPagination.fromJson(data['pagination'] ?? {}),
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
      companyName: json['companyName'] ?? '',
      product: CartProduct.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 0,
      cartPrice: json['cartPrice'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
    );
  }
}

class CartProduct {
  final String name;
  final String? thumbnailImage;
  final Map<String, dynamic> options;
  final String status;
  final int totalPrice;
  final Discount? discount;

  CartProduct({
    required this.name,
    required this.thumbnailImage,
    required this.options,
    required this.status,
    required this.totalPrice,
    this.discount,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(

      name: json['name'] ?? '',
      thumbnailImage: json['thumbnailImage'],
      options: json['options'] ?? {},
      status: json['status'] ?? '',
      totalPrice: json['totalPrice'] ?? 0,
      discount: json['discount'] == null ? null : Discount.fromJson(
          json['discount']),

    );
  }
}

class Discount {
  final String type;
  final int amount;
  final int originalPrice;
  final int discountPrice;

  Discount({
    required this.type,
    required this.amount,
    required this.originalPrice,
    required this.discountPrice,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      type: json['type'] ?? '',
      amount: json['amount'] ?? '',
      originalPrice: json['originalPrice'] ?? '',
      discountPrice: json['discountPrice'] ?? '',
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

class RemoveCartResult {
  final int removedCount;
  final int remainingItems;

  RemoveCartResult({required this.removedCount, required this.remainingItems});

  // 'data' 필드를 직접 처리하는 로직 제거
  factory RemoveCartResult.fromJson(Map<String, dynamic> json) {
    return RemoveCartResult(
      removedCount: json['removedCount'] ?? 0,
      remainingItems: json['remainingItems'] ?? 0,
    );
  }
}
