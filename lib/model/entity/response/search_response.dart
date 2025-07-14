import 'dart:convert';

import 'package:look_talk/model/entity/response/discount_dto.dart';

class ProductSearch {
  final String id;
  final String name;
  final String description;
  final int price;
  final String? thumbnailImage;
  final String? storeName;
  final DiscountDto? discount;

  ProductSearch({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.thumbnailImage,
    required this.storeName,
    required this.discount
  });

  factory ProductSearch.fromJson(Map<String, dynamic> json) {
    DiscountDto? discount;

    final rawDiscount = json['discount'];
    if (rawDiscount != null && rawDiscount is String && rawDiscount.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawDiscount);
        discount = DiscountDto.fromjson(decoded);
      } catch (e) {
        discount = null;
      }
    }
    return ProductSearch(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      thumbnailImage: json['thumbnailImageUrl'] ??
          (json['thumbnailImage'] is Map && json['thumbnailImage']?['url'] != null
              ? json['thumbnailImage']['url'].toString()
              : null),
      storeName: json['store']?['name'],
      discount: discount,
    );
  }
}

class CommunitySearch {
  final String id;
  final String category;
  final String title;
  final String? images;
  final String createdAt;


  CommunitySearch({
    required this.id,
    required this.title,
    required this.category,
    required this.images,
    required this.createdAt,
  });

  factory CommunitySearch.fromJson(Map<String, dynamic> json) {
    String? extractMainImage(dynamic images) {
      if (images is List && images.isNotEmpty) {
        final first = images[0];
        if (first is Map && first['url'] is Map && first['url']['main'] is String) {
          return first['url']['main'];
        }
      }
      return null;
    }

    return CommunitySearch(
        id: json['id'],
        title: json['title'],
        category: json['category'],
        images: extractMainImage(json['images']),
        createdAt : json['createdAt']
    );
  }
}


class SearchResponse {
  final List<ProductSearch> products;
  final List<CommunitySearch> community;

  SearchResponse({required this.products, required this.community});

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final productList = (json['data']['products'] as List)
        .map((e) => ProductSearch.fromJson(e))
        .toList();

    final communityList = (json['data']['posts'] as List)
        .map((e) => CommunitySearch.fromJson(e))
        .toList();

    return SearchResponse(products: productList, community: communityList);
  }
}
