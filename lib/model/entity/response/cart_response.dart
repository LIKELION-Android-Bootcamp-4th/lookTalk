// lib/model/entity/response/cart_response.dart

// 우리가 만든 새로운 통합 Product 모델을 가져옵니다.
import 'package:look_talk/model/entity/response/product_response.dart';

// ===================================================================
// 장바구니 전체 응답 클래스
// ===================================================================
class CartResponse {
  final String? id; // [수정] id가 없을 수 있으므로 nullable로 변경
  final List<CartItem> items;
  final Pagination? pagination;

  CartResponse({
    this.id, // [수정] 필수값이 아니므로 required 제거
    required this.items,
    this.pagination,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return CartResponse(
      // [핵심 수정] id가 없으면 빈 문자열 대신 null을 할당하도록 변경합니다.
      id: json['id'] as String?,
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
// 페이지네이션 정보 클래스
// ===================================================================
class Pagination {
  // 페이지네이션 관련 필드들을 여기에 정의합니다.
  // 예: final int page;
  // 예: final int totalPages;

  Pagination(); // 예시 생성자

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      // JSON 파싱 로직
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