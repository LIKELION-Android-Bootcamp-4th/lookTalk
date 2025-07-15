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

  OrderProductSummary({
    required this.id,
    required this.name,
    required this.price,
    this.thumbnailImage,
    this.storeName,
    this.discount,
    this.size,
    this.userNickName
  });

  factory OrderProductSummary.fromJson(Map<String, dynamic> json, String? storeName, String? userNickName) {
    final options = json['options'];
    final size = options != null ? options['size'] ?? '' : '';

    return OrderProductSummary(
      id: json['id'],
      name: json['productName'],
      price: json['totalPrice'],
      thumbnailImage: _extractThumbnail(json['images']),
      storeName: storeName,
      userNickName: userNickName,
      discount: null, // 현재 discount 필드 없음
      size: size,
    );
  }

  static String? _extractThumbnail(dynamic imagesJson) {
    if (imagesJson is String) {
      final decoded = jsonDecode(imagesJson);
      return decoded['main'];
    } else if (imagesJson is Map<String, dynamic>) {
      return imagesJson['main'];
    }
    return null;
  }
}
