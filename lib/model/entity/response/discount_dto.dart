class DiscountDto {
  final int value;

  DiscountDto({required this.value});

  factory DiscountDto.fromjson(Map<String, dynamic> json) {
    final raw = json['value'] ?? json['rate'];
    int parsedValue = 0;

    if (raw is int) {
      parsedValue = raw;
    } else if (raw is String) {
      parsedValue = int.tryParse(raw) ?? 0;
    }

    return DiscountDto(value: parsedValue);
  }

  Map<String, dynamic> toJson() => {
    'type': 'percentage',
    'value': value,
  };
}
