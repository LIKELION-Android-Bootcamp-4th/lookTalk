import 'dart:convert';

import 'package:look_talk/model/entity/response/discount_dto.dart';

class Product {
  final String? productId;
  final String name;
  final String? description;
  final int? stock;
  final int price;
  final String? categoryId; // 카테고리 ID
  final String? category;   // 카테고리 이름
  final Map<String, dynamic>? options;
  final DiscountDto? discount;
  final String? status;
  final String? thumbnailImagePath;
  final String? contentImagePath;
  final Map<String, dynamic>? images;
  final Map<String, dynamic>? attributes;
  final Map<String, dynamic>? dynamicFields;
  final String? storeName;

  Product({
    this.productId,
    required this.name,
    required this.price,
    this.description,
    this.stock,
    this.categoryId,
    this.category,
    this.options,
    this.discount,
    this.status,
    this.thumbnailImagePath,
    this.contentImagePath,
    this.images,
    this.attributes,
    this.dynamicFields,
    this.storeName
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    const knownKeys = {
      'id',
      'name',
      'description',
      'stock',
      'price',
      'categoryId',
      'category',
      'options',
      'discount',
      'status',
      'thumbnailImageUrl', // ✅ 수정
      'contentImageUrl',   // ✅ 수정
      'images',
      'attributes',
      'storeName',
    };

    final dynamicFieldMap = <String, dynamic>{};
    for (final entry in json.entries) {
      if (!knownKeys.contains(entry.key)) {
        dynamicFieldMap[entry.key] = entry.value;
      }
    }

    DiscountDto? parsedDiscount;
    final rawDiscount = json['discount'];

    try {
      if (rawDiscount is String && rawDiscount.isNotEmpty) {
        parsedDiscount = DiscountDto.fromjson(jsonDecode(rawDiscount));
      } else if (rawDiscount is Map<String, dynamic>) {
        parsedDiscount = DiscountDto.fromjson(rawDiscount);
      }
    } catch (e) {
      print('discount 파싱 실패: $e');
      parsedDiscount = null;
    }

    return Product(
      productId: json['id']?.toString(),
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'],
      stock: json['stock'],
      categoryId: json['categoryId'],
      category: json['category'], // 카테고리 필드
      options: _parseJsonField(json['options']),
      discount: parsedDiscount,
      status: json['status'],
      thumbnailImagePath: json['thumbnailImageUrl'],
      contentImagePath: json['contentImageUrl'],
      images: _parseJsonField(json['images']),
      attributes: _parseJsonField(json['attributes']),
      dynamicFields: dynamicFieldMap.isNotEmpty ? dynamicFieldMap : null,
      storeName: json['store']?['name'],
    );
  }

  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> data = {
      'name': name,
      'price': price,
    };

    if (description != null) data['description'] = description;
    if (stock != null) data['stock'] = stock;
    if (categoryId != null) data['categoryId'] = categoryId;  // categoryId 추가
    if (category != null) data['category'] = category;        // category 추가
    if (options != null) data['options'] = options;
    if (discount != null) data['discount'] = discount;
    if (status != null) data['status'] = status;
    if (images != null) data['images'] = images;
    if (attributes != null) data['attributes'] = attributes;
    if (dynamicFields != null) data.addAll(dynamicFields!);

    return data;
  }

  /// ✅ 할인률 (percent), 할인된 최종 가격, 원래 가격
  int get discountPercent {
    return discount?.value ?? 0;
  }

  int get originalPrice => price;

  int get finalPrice {
    return (price * (100 - discountPercent) / 100).round();
  }

  /// ✅ 이미지 URL getter
  String get imageUrl => thumbnailImagePath ?? '';
  static Map<String, dynamic>? _parseJsonField(dynamic field) {
    try {
      if (field == null) return null;
      if (field is String && field.isNotEmpty) {
        return jsonDecode(field) as Map<String, dynamic>;
      } else if (field is Map<String, dynamic>) {
        return field;
      }
    } catch (e) {
      print('필드 파싱 실패: $e');
    }
    return null;
  }
}
