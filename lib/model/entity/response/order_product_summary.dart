import 'dart:convert';

import 'discount_dto.dart';

class OrderProductSummary {
  final String id;
  final String name;
  final int price;
  final String? thumbnailImage;
  final String? storeName;
  final String? userNickName;
  final DiscountDto? discount;
  final String? size;
  final int? quantity;

  OrderProductSummary({
    required this.id,
    required this.name,
    required this.price,
    this.thumbnailImage,
    this.storeName,
    this.discount,
    this.size,
    this.userNickName,
    this.quantity,
  });

  factory OrderProductSummary.fromJson(
      Map<String, dynamic> json, String? storeName, String? userNickName) {
    final options = json['options'];
    final size = options != null ? options['size'] ?? '' : '';

    return OrderProductSummary(
      id: json['id'],
      name: json['productName'],
      price: json['totalPrice'],
      thumbnailImage: json['thumbnailImageUrl'] ,
      storeName: storeName,
      userNickName: userNickName,
      discount: null, // 현재 discount 파싱 미적용
      size: size,
      quantity: json['quantity']
    );
  }


  /// 💡 productId 라는 이름으로도 접근 가능하게 하기
  String get productId => id;
}
