import 'dart:convert';
import 'package:look_talk/model/entity/response/discount_dto.dart';

class ProductEntity {
  final String? productId;
  final String name;
  final String? description;
  final int? stock;
  final int price;
  final String? categoryId;
  final String? category;
  final Map<String, dynamic>? options;
  final DiscountDto? discount;
  final String? status;
  final String? thumbnailUrl;
  final String? contentImagePath;
  final Map<String, dynamic>? images;
  final Map<String, dynamic>? attributes;
  final Map<String, dynamic>? dynamicFields;
  final String? storeName;

  ProductEntity({
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
    this.thumbnailUrl,
    this.contentImagePath,
    this.images,
    this.attributes,
    this.dynamicFields,
    this.storeName,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
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
      'thumbnailImageUrl',
      'contentImageUrl',
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

    return ProductEntity(
      productId: json['id']?.toString(),
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'],
      stock: json['stock'],
      categoryId: json['categoryId'],
      category: json['category'],
      options: _parseJsonField(json['options']),
      discount: parsedDiscount,
      status: json['status'],
      thumbnailUrl: json['thumbnailImage']?['url'] ?? json['thumbnailImageUrl'],
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
    if (categoryId != null) data['categoryId'] = categoryId;
    if (category != null) data['category'] = category;
    if (options != null) data['options'] = options;
    if (discount != null) {
      data['discount'] = jsonEncode(discount!.toJson());
    }
    if (status != null) data['status'] = status;
    if (images != null) data['images'] = images;
    if (attributes != null) data['attributes'] = attributes;
    if (dynamicFields != null) data.addAll(dynamicFields!);

    return data;
  }

  int get discountPercent => discount?.value ?? 0;

  int get originalPrice => price;

  int get finalPrice => (price * (100 - discountPercent) / 100).round();

  /// 기본 대표 이미지
  String get imageUrl => thumbnailUrl ?? '';

  /// 설명용 이미지. 없으면 contentImagePath, 없으면 썸네일로 fallback
  String get detailImageUrl {
    final detailList = images?['detail'];
    if (detailList is List && detailList.isNotEmpty && detailList.first is String) {
      return detailList.first;
    }
    return contentImagePath ?? thumbnailUrl ?? '';
  }

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
