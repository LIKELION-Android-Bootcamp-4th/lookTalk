// lib/model/entity/response/cart_response.dart

// 우리가 만든 새로운 통합 Product 모델을 가져옵니다.
import 'package:look_talk/model/entity/response/product_response.dart';

// ===================================================================
// 장바구니 전체 응답 클래스
// ===================================================================
class CartResponse {
  final List<CartItem> items;
  final Pagination? pagination;

  CartResponse({required this.items, this.pagination});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return CartResponse(
      items: itemsList.map((item) => CartItem.fromJson(item as Map<String, dynamic>)).toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }
}

// ===================================================================
// 장바구니 개별 아이템 클래스
// ===================================================================
class CartItem {
  final String id; // 장바구니 아이템의 고유 ID
  final int quantity;
  final int cartPrice; // 장바구니에 담길 당시의 가격
  final int totalPrice;
  final Product product; // [핵심] 상품 상세 정보는 통합 Product 모델을 재사용합니다.

  CartItem({
    required this.id,
    required this.quantity,
    required this.cartPrice,
    required this.totalPrice,
    required this.product,
  });

  // `fromJson` 생성자가 모든 방어적 코드가 적용된 Product.fromJson을 호출합니다.
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      cartPrice: json['cartPrice'] as int? ?? 0,
      totalPrice: json['totalPrice'] as int? ?? 0,
      // product 필드가 null이거나 Map이 아닐 경우를 대비해 빈 객체를 넘겨줍니다.
      product: Product.fromJson(json['product'] as Map<String, dynamic>? ?? {}),
    );
  }
}


// ===================================================================
// 장바구니 아이템 삭제 결과 클래스
// ===================================================================
class RemoveCartResult {
  final int deletedCount;
  RemoveCartResult({required this.deletedCount});

  factory RemoveCartResult.fromJson(Map<String, dynamic> json) {
    return RemoveCartResult(
      deletedCount: json['deletedCount'] as int? ?? 0,
    );
  }
}