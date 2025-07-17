import 'package:look_talk/model/entity/response/product_response.dart';

/// ===================================================================
/// 장바구니 전체 응답 클래스
/// ===================================================================
class CartResponse {
  final List<CartItem> items;
  final Pagination? pagination;

  CartResponse({required this.items, this.pagination});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return CartResponse(
      items: itemsList
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// ===================================================================
/// 장바구니 개별 아이템 클래스
/// ===================================================================
class CartItem {
  final String? id; // 장바구니 아이디 (nullable: 직접 생성 시 없음)
  final int quantity;
  final int cartPrice; // 단가
  final int totalPrice; // 수량 * 단가
  final Product product; // product_response.dart 기준 Product
  final Map<String, String>? selectedOptions;
  final String? storeName;

  CartItem({
    this.id,
    required this.quantity,
    required this.cartPrice,
    required this.totalPrice,
    required this.product,
    this.selectedOptions,
    this.storeName
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String?,
      quantity: json['quantity'] as int? ?? 0,
      cartPrice: json['cartPrice'] as int? ?? 0,
      totalPrice: json['totalPrice'] as int? ?? 0,
      product: Product.fromJson(json['product'] as Map<String, dynamic>? ?? {}),
      selectedOptions: (json['options'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
      ),
      storeName: json['storeName'] as String? ?? ''
    );
  }
}

/// ===================================================================
/// 장바구니 아이템 삭제 결과 클래스
/// ===================================================================
class RemoveCartResult {
  final int deletedCount;

  RemoveCartResult({required this.deletedCount});

  factory RemoveCartResult.fromJson(Map<String, dynamic> json) {
    return RemoveCartResult(
      deletedCount: json['deletedCount'] as int? ?? 0,
    );
  }
}

/// ===================================================================
/// 페이지네이션 정보 클래스 (재사용 가능)
/// ===================================================================
class Pagination {
  final int currentPage;
  final int totalPages;
  final int total;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      total: json['total'] as int? ?? 0,
    );
  }
}
