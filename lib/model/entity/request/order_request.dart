class OrderRequest {
  final List<OrderItemRequest> items;
  final ShippingInfo shippingInfo;
  final String? memo;

  OrderRequest({
    required this.items,
    required this.shippingInfo,
    this.memo,
  });

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'shippingInfo': shippingInfo.toJson(),
    if (memo != null) 'memo': memo,
  };
}

class OrderItemRequest {
  final String product;
  final int quantity;
  final Map<String, dynamic> options;
  final int unitPrice;

  OrderItemRequest({
    required this.product,
    required this.quantity,
    required this.options,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() => {
    'product': product,
    'quantity': quantity,
    'options': options,
    'unitPrice': unitPrice,
  };
}

class ShippingInfo {
  final String recipient;
  final String address;
  final String phone;

  ShippingInfo({
    required this.recipient,
    required this.address,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    'recipient': recipient,
    'address': address,
    'phone': phone,
  };
}