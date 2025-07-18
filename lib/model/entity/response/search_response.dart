import 'dart:convert';

import 'package:look_talk/model/entity/response/discount_dto.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import 'package:look_talk/model/entity/response/post_user_response.dart';

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

// class CommunitySearch {
//   final String id;
//   final String title;
//   final String content;
//   final String category;
//   final int likeCount;
//   final int commentCount;
//   final String createdAt;
//   final PostUserResponse? user;
//   final String? images;
//   final bool isLiked;
//   final ProductResponse? product;
//
//   CommunitySearch({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.category,
//     required this.likeCount,
//     required this.commentCount,
//     required this.createdAt,
//     required this.user,
//     required this.images,
//     required this.isLiked,
//     this.product,
//   });
//
//   factory CommunitySearch.fromJson(Map<String, dynamic> json) {
//     String? extractMainImage(dynamic images) {
//       if (images is List && images.isNotEmpty) {
//         final first = images[0];
//         if (first is Map && first['url'] is Map && first['url']['main'] is String) {
//           return first['url']['main'];
//         }
//       }
//       return null;
//     }
//
//     return CommunitySearch(
//       id: json['id']?.toString() ?? '',
//       title: json['title'] ?? '',
//       content: json['content'] ?? '',
//       category: json['category'],
//       likeCount: json['likeCount'] ?? 0,
//       commentCount: json['commentCount'] ?? 0,
//       createdAt: json['createdAt'],
//       user: json['user'] != null ? PostUserResponse.fromJson(json['user']) : null,
//       images: extractMainImage(json['images']),
//       isLiked: json['isLiked'] ?? false,
//       product: json['product'] != null ? ProductResponse.fromJson(json['product']) : null,
//     );
//   }
// }


class SearchResponse {
  final List<ProductSearch> products;
  final List<PostResponse> community;

  SearchResponse({required this.products, required this.community});

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final productList = (json['data']['products'] as List)
        .map((e) => ProductSearch.fromJson(e))
        .toList();

    final communityList = (json['data']['posts'] as List)
        .map((e) => PostResponse.fromJson(e))
        .toList();

    return SearchResponse(products: productList, community: communityList);
  }
}
