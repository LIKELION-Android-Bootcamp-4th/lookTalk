class ProductSearch {
  final String id;
  final String name;
  final String description;
  final int price;
  final List<String> images;
  final String? storeName;

  ProductSearch({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.storeName,
  });

  factory ProductSearch.fromJson(Map<String, dynamic> json) {
    return ProductSearch(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      images: (json['images'] is List)
          ? List<String>.from(json['images'])
          : [],
      storeName: json['store']?['name'],
    );
  }
}

class CommunitySearch {
  final String id;
  final String title;
  final int viewCount;
  final int likeCount;

  CommunitySearch({
    required this.id,
    required this.title,
    required this.viewCount,
    required this.likeCount,
  });

  factory CommunitySearch.fromJson(Map<String, dynamic> json) {
    return CommunitySearch(
      id: json['_id'],
      title: json['title'],
      viewCount: json['viewCount'],
      likeCount: json['likeCount'],
    );
  }
}


class SearchResponse {
  final List<ProductSearch> products;
  final List<CommunitySearch> community;

  SearchResponse({required this.products, required this.community});

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final productList = (json['data']['products']['items'] as List)
        .map((e) => ProductSearch.fromJson(e))
        .toList();

    final communityList = (json['data']['contents']['items'] as List)
        .map((e) => CommunitySearch.fromJson(e))
        .toList();

    return SearchResponse(products: productList, community: communityList);
  }
}
