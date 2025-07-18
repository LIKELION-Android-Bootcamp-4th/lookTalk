import 'order_product_summary.dart';

class OrderListResponse {
  final String oderId;
  final String status;
  final String createdAt;
  final List<OrderProductSummary> items;
  final int? totalAmount;
  final bool refundInfo;

  OrderListResponse({
    required this.oderId,
    required this.status,
    required this.createdAt,
    required this.items,
    this.totalAmount,
    required this.refundInfo,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    final storeName = json['storeId'] is Map
        ? json['storeId']['name']
        : null;
    final userNickName = json['userId'] is Map
        ? json['userId']['nickName']
        : null;
    final productList = (json['items'] as List)
        .map((item) => OrderProductSummary.fromJson(item, storeName, userNickName))
        .toList();

    return OrderListResponse(
      oderId: json['id'],
      status: json['status'],
      createdAt: json['createdAt'],
      items: productList,
      totalAmount: json['totalAmount'],
      refundInfo: json['refundInfo']  != null
    );
  }
}
