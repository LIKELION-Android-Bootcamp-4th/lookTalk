class CheckoutRequest {
  final ShippingInfoRequest shippingInfo;
  final String? memo;
  final List<String> cartIds;

  CheckoutRequest({
    required this.shippingInfo,
    this.memo,
    required this.cartIds,
  });

  Map<String, dynamic> toJson() => {
    'shippingInfo': shippingInfo.toJson(),
    'memo': memo,
    'cartIds': cartIds,
  };
}

// 배송 정보 모델은 기존과 동일하게 사용합니다.
class ShippingInfoRequest {
  final String recipient;
  final String phone;
  final String address;
  final String? zipCode; // API 명세에 있으므로 추가

  ShippingInfoRequest({
    required this.recipient,
    required this.phone,
    required this.address,
    this.zipCode,
  });

  Map<String, dynamic> toJson() => {
    'recipient': recipient,
    'phone': phone,
    'address': address,
    'zipCode': zipCode,
  };
}