import 'dart:convert';

import 'package:look_talk/model/entity/response/discount_dto.dart';

class Home {
  final String id;
  final String name;
  final String description;
  final int price;
  final String? thumbnailImage;
  final String? storeName;
  final DiscountDto? discount;

  Home({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.thumbnailImage,
    required this.storeName,
    required this.discount
  });

  factory Home.fromJson(Map<String, dynamic> json) {
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
    return Home(
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

class HomeResponse {
  final List<Home> homeProduct;

  HomeResponse({required this.homeProduct});

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    final homeProduct = (json['data']['items'] as List)
        .map((e) => Home.fromJson(e))
        .toList();

    final rawDiscount = json['discount'];
    print('rawDiscount: $rawDiscount (${rawDiscount.runtimeType})');
    return HomeResponse(homeProduct: homeProduct);
  }
}
