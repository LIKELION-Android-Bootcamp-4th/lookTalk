class Product {
  final String name;
  final String code;
  final String? brand;
  final int? price;
  final int? originalPrice;
  final int? discountPercent;
  final List<String> imageUrls;
  final bool isWishlisted;
  final int wishlistCount;

  Product({
    required this.name,
    required this.code,
    this.brand,
    this.price,
    this.originalPrice,
    this.discountPercent,
    this.imageUrls = const [],
    this.isWishlisted = false,
    this.wishlistCount = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> parseImageUrls(dynamic images) {
      if (images is List) {
        return List<String>.from(images.map((item) => item.toString()));
      }
      if (images is String) {
        return [images];
      }
      return [];
    }

    return Product(
      name: json['name'] as String? ?? '이름 없음',
      code: json['id'] as String? ?? '',
      brand: json['brand'] as String?,
      price: json['price'] as int?,
      originalPrice: json['originalPrice'] as int?,
      discountPercent: json['discountPercent'] as int?,
      imageUrls: parseImageUrls(json['images']),
      isWishlisted: json['isWishlisted'] as bool? ?? false,
      wishlistCount: json['wishlistCount'] as int? ?? 0,
    );
  }
}
