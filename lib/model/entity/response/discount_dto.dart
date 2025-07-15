class DiscountDto {
  final int value;

  DiscountDto({
    required this.value,
  });

  factory DiscountDto.fromjson(Map<String, dynamic> json) {
    return DiscountDto(
      value: json['rate'] ?? 0,);
  }

  Map<String, dynamic> toJson() => {
    'rate': value,
  };
}
