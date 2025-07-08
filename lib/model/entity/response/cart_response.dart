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
    return CartResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromJson(e))
          .toList(),
      pagination: CartPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class CartItem {
  final String id;
  final CartProduct product;
  final int quantity;
  final int cartPrice;
  final int totalPrice;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.cartPrice,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
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
  final int unitPrice;
  final bool priceChanged;
  final Map<String, dynamic> options;
  final String status;
  final String stockType;
  final int stock;
  final bool isAvailable;

  CartProduct({
    required this.id,
    required this.name,
    this.thumbnailImage,
    required this.unitPrice,
    required this.priceChanged,
    required this.options,
    required this.status,
    required this.stockType,
    required this.stock,
    required this.isAvailable,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      thumbnailImage: json['thumbnailImage'],
      unitPrice: json['unitPrice'] ?? 0,
      priceChanged: json['priceChanged'] ?? false,
      options: json['options'] ?? {},
      status: json['status'] ?? '',
      stockType: json['stockType'] ?? '',
      stock: json['stock'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
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

  RemoveCartResult({
    required this.removedCount,
    required this.remainingItems,
  });

  // 'data' 필드를 직접 처리하는 로직 제거
  factory RemoveCartResult.fromJson(Map<String, dynamic> json) {
    return RemoveCartResult(
      removedCount: json['removedCount'] ?? 0,
      remainingItems: json['remainingItems'] ?? 0,
    );
  }
}