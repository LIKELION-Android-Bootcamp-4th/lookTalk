import 'order_product_summary.dart';

class OrderListResponse {
  final String oderId;
  final String status;
  final String createdAt;
  final List<OrderProductSummary> items;
  final int? totalAmount;

  OrderListResponse({
    required this.oderId,
    required this.status,
    required this.createdAt,
    required this.items,
    this.totalAmount
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    final storeName = json['storeId']?['name'];
    final productList = (json['items'] as List)
        .map((item) => OrderProductSummary.fromJson(item, storeName))
        .toList();

    return OrderListResponse(
      oderId: json['id'],
      status: json['status'],
      createdAt: json['createdAt'],
      items: productList,
      totalAmount: json['totalAmount']
    );
  }
}
