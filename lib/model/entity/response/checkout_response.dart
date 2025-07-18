class CheckoutResponse {
  final List<OrderData> orders;

  CheckoutResponse({required this.orders});

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      orders: (json['orders'] as List<dynamic>? ?? [])
          .map((e) => OrderData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderData {
  final String id;
  final String orderNumber;
  final int totalAmount;

  OrderData({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    final doc=json['_doc']??json;
    return OrderData(
      id: doc['id'] ?? '',
      orderNumber: doc['orderNumber'] ?? '',
      totalAmount: doc['totalAmount'] ?? 0,
    );
  }
}