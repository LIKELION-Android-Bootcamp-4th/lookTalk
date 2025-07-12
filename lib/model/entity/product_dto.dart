class ProductSearch {
  final String id;
  final String name;
  final String description;
  final int price;
  final List<String> images;
  final double averageRating;
  final int reviewCount;
  final bool isFavorite;
  final double searchScore;

  ProductSearch({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.averageRating,
    required this.reviewCount,
    required this.isFavorite,
    required this.searchScore,
  });
  factory ProductSearch.fromJson(Map<String, dynamic> json) {
    return ProductSearch(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      images: List<String>.from(json['images']),
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewCount: json['reviewCount'],
      isFavorite: json['isFavorite'],
      searchScore: (json['searchScore'] as num).toDouble(),
    );
  }
}