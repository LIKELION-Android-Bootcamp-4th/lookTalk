// lib/model/entity/request/create_order_request.dart

class CreateOrderRequest {
  final List<OrderItemRequest> items;
  final ShippingInfoRequest shippingInfo;

  CreateOrderRequest({required this.items, required this.shippingInfo});

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'shippingInfo': shippingInfo.toJson(),
    };
  }
}

class OrderItemRequest {
  final String productId;
  final int quantity;
  final Map<String, dynamic> options;
  final int unitPrice;

  OrderItemRequest({
    required this.productId,
    required this.quantity,
    required this.options,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': productId, // API 명세에 따라 'product' 키로 productId를 전달
      'quantity': quantity,
      'options': options,
      'unitPrice': unitPrice,
    };
  }
}

class ShippingInfoRequest {
  final String recipient;
  final String phone;
  final String address;
  final String? memo;

  ShippingInfoRequest({
    required this.recipient,
    required this.phone,
    required this.address,
    this.memo,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'phone': phone,
      'address': address,
      'memo': memo ?? '',
    };
  }
}
