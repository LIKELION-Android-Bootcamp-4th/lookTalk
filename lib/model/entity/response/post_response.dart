import 'package:look_talk/model/entity/response/comment_response.dart';
import 'package:look_talk/model/entity/response/post_user_response.dart';
import 'dart:convert';
import '../comment.dart';

class PostResponse {
  final String id;
  final String title;
  final String content;
  final String category;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final PostUserResponse? user;
  final List<String> images;
  final bool isLiked;
  final List<Comment> comments;
  final ProductResponse? product;
  final String? thumbnailImage;


  PostResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.user,
    required this.images,
    required this.isLiked,
    required this.comments,
    this.product,
    this.thumbnailImage,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    print("PostResponse.fromJson 호출됨: ${json['title']}");
    final imageList = json['images'] as List<dynamic>? ?? [];

    String? mainThumbnail;
    for (final img in imageList) {
      if (img is Map<String, dynamic>) {
        final url = img['url'];
        if (url is Map<String, dynamic> && url['main'] is String) {
          mainThumbnail = url['main'];
          break;
        }
      }
    }

    return PostResponse(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'],
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      user: json['user'] != null ? PostUserResponse.fromJson(json['user']) : null,
      images: (json['images'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map((e) => e['url'])
          .whereType<String>()
          .toList() ?? [],
      isLiked: json['isLiked'],
      comments: (json['comments'] as List<dynamic>?) ?.map((e) => Comment.fromJson(e)).toList() ?? [],
      product: json['product'] != null ? ProductResponse.fromJson(json['product']) : null,
      thumbnailImage: mainThumbnail,
    );
  }
}


class ProductResponse {
  final String id;
  final String name;
  final int price;
  final String? thumbnailImageUrl;
  final String? storeName;
  final Discount? discount;

  ProductResponse({
    required this.id,
    required this.name,
    required this.price,
    this.thumbnailImageUrl,
    this.storeName,
    this.discount,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final store = json['store'] as Map<String, dynamic>?;
    final dynamic discountJson = json['discount'];

    Discount? parsedDiscount;

    if (discountJson != null) {
      try {
        if (discountJson is String) {
          final parsedMap = jsonDecode(discountJson);
          if (parsedMap is Map<String, dynamic>) {
            parsedDiscount = Discount.fromJson(parsedMap);
          }
        } else if (discountJson is Map<String, dynamic>) {
          parsedDiscount = Discount.fromJson(discountJson);
        } else if (discountJson is int) {
          parsedDiscount = Discount(value: discountJson);
        }
      } catch (e) {
        print('discount 파싱 실패: $e');
      }
    }

    return ProductResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      thumbnailImageUrl: json['thumbnailImageUrl'],
      storeName: store?['name'],
      discount: parsedDiscount,
    );
  }
}

class Discount {
  final int value;

  Discount({required this.value});

  factory Discount.fromJson(Map<String, dynamic> json) {
    final raw = json['value'] ?? json['rate'];
    int parsed = 0;

    if (raw is int) {
      parsed = raw;
    } else if (raw is String) {
      parsed = int.tryParse(raw) ?? 0;
    }

    return Discount(value: parsed);
  }

}


