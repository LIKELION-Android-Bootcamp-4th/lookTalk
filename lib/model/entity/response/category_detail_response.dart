import 'dart:convert';

import 'package:look_talk/model/entity/response/discount_dto.dart';

class CategoryDetailResponse {
  final String id;
  final String name;
  final String description;
  final int price;
  final String? thumbnailImage;
  final String? storeName;
  final DiscountDto? discount;

  CategoryDetailResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.thumbnailImage,
    required this.storeName,
    required this.discount
  });

  factory CategoryDetailResponse.fromJson(Map<String, dynamic> json) {
    DiscountDto? discount;

    final rawDiscount = json['discount'];
    if (rawDiscount != null && rawDiscount is String &&
        rawDiscount.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawDiscount);
        discount = DiscountDto.fromjson(decoded);
      } catch (e) {
        discount = null;
      }
    }
    return CategoryDetailResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      thumbnailImage: json['thumbnailImageUrl'] ??
          (json['thumbnailImage'] is Map &&
              json['thumbnailImage']?['url'] != null
              ? json['thumbnailImage']['url'].toString()
              : null),
      storeName: json['store']?['name'],
      discount: discount,
    );
  }
}