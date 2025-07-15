import 'package:look_talk/model/entity/product_entity.dart' as entity;

import 'dart:convert';

T? _parseJson<T>(dynamic jsonData, T Function(Map<String, dynamic>) fromJson) {
  if (jsonData == null) return null;

  if (jsonData is Map<String, dynamic>) {
    return fromJson(jsonData);
  }

  if (jsonData is String && jsonData.isNotEmpty) {
    try {
      final decoded = json.decode(jsonData);
      if (decoded is Map<String, dynamic>) {
        return fromJson(decoded);
      }
    } catch (e) {
      print('Failed to decode JSON string: \$jsonData, Error: \$e');
      return null;
    }
  }
  return null;
}

List<T>? _parseJsonList<T>(dynamic jsonData, T Function(Map<String, dynamic>) fromJson) {
  if (jsonData == null) return null;

  List<dynamic>? list;

  if (jsonData is List) {
    list = jsonData;
  } else if (jsonData is String && jsonData.isNotEmpty) {
    try {
      final decoded = json.decode(jsonData);
      if (decoded is List) {
        list = decoded;
      }
    } catch (e) {
      print('Failed to decode JSON list string: \$jsonData, Error: \$e');
      return null;
    }
  }

  if (list != null) {
    return list
        .where((item) => item is Map<String, dynamic>)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }
  return null;
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final T data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? 'Unknown error',
      data: fromJsonT(json['data']),
    );
  }
}

class ProductListData {
  final List<Product> items;
  final Pagination pagination;

  ProductListData({required this.items, required this.pagination});

  factory ProductListData.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return ProductListData(
      items: itemsList.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int total;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      total: json['total'] as int? ?? 0,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String? description;
  final int price;
  final int? stock;
  final String? thumbnailImageUrl;
  final ImageInfo? thumbnailImage;
  final Category? category;
  final Store? store;
  final Discount? discount;
  final List<OptionGroup> options;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.stock,
    this.thumbnailImageUrl,
    this.thumbnailImage,
    this.category,
    this.store,
    this.discount,
    required this.options,
    required this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? 'unknown_id_\${DateTime.now().millisecondsSinceEpoch}',
      name: json['name'] as String? ?? '이름 없음',
      description: json['description'] as String?,
      price: json['price'] as int? ?? 0,
      stock: json['stock'] as int?,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String?,
      thumbnailImage: _parseJson(json['thumbnailImage'], (d) => ImageInfo.fromJson(d)),
      category: _parseJson(json['category'], (d) => Category.fromJson(d)),
      store: _parseJson(json['store'], (d) => Store.fromJson(d)),
      discount: _parseJson(json['discount'], (d) => Discount.fromJson(d)),
      options: _parseJsonList(json['options'], (o) => OptionGroup.fromJson(o)) ?? [],
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  /// ✅ ProductEntity → Product 변환용 생성자
  factory Product.fromEntity(entity.ProductEntity e) {
    return Product(
      id: e.productId ?? 'unknown_id_${DateTime.now().millisecondsSinceEpoch}',
      name: e.name,
      description: null,
      price: e.price,
      stock: null,
      thumbnailImageUrl: e.thumbnailUrl,
      thumbnailImage: null,
      category: e.category != null ? Category(id: e.category!, name: '') : null,
      store: Store(id: 'unknown', name: e.storeName ?? ''),
      discount: Discount(type: 'percent', value: e.discountPercent ?? 0),
      options: [],
      isFavorite: false,
    );
  }
}

class ImageInfo {
  final String? id;
  final String? url;

  ImageInfo({this.id, this.url});

  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      id: json['id'] as String?,
      url: json['url'] as String?,
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class Store {
  final String id;
  final String name;

  Store({required this.id, required this.name});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class Discount {
  final String type;
  final int value;
  final String? condition;

  Discount({required this.type, required this.value, this.condition});

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      type: json['type'] as String? ?? 'none',
      value: json['value'] as int? ?? 0,
      condition: json['condition'] as String?,
    );
  }
}

class OptionGroup {
  final String name;
  final List<OptionItem> items;

  OptionGroup({required this.name, required this.items});

  factory OptionGroup.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return OptionGroup(
      name: json['name'] as String? ?? '옵션',
      items: itemsList.map((item) => OptionItem.fromJson(item)).toList(),
    );
  }
}

class OptionItem {
  final String name;
  final int stock;
  final int price;

  OptionItem({required this.name, required this.stock, required this.price});

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    return OptionItem(
      name: json['name'] as String? ?? '',
      stock: json['stock'] as int? ?? 0,
      price: json['price'] as int? ?? 0,
    );
  }
}