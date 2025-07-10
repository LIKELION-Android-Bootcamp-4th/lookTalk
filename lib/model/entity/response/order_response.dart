class OrderResponse {
  final String orderId;
  final String orderNumber;
  final int totalAmount;

  OrderResponse({
    required this.orderId,
    required this.orderNumber,
    required this.totalAmount,
  });

  // [✅ 수정된 부분]
  // 서버 응답의 'data' 객체에서 바로 데이터를 파싱하도록 수정
  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      totalAmount: json['totalAmount'] ?? 0,
    );
  }
}
