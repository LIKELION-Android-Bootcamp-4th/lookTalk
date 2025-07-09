class Product {
  final String name;
  final String code;
  // final String? description;
  // final int? price;

  Product({
    required this.name,
    required this.code,
    // this.description,
    // this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String? ?? '이름 없음',
      code: json['id'] as String? ?? '',
    );
  }
}
