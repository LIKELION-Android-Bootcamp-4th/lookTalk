class CategoryDetailResponse {
  final String id;
  final String name;
  final String description;
  final int price;
  final List<String> images;
  final String? storeName;

  CategoryDetailResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.storeName,
  });

  factory CategoryDetailResponse.fromJson(Map<String, dynamic> json) {
    return CategoryDetailResponse(
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