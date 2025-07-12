class DiscountDto {
  final int value;
  // final DateTime from;
  // final DateTime to;

  DiscountDto({
    required this.value,
    // required this.from,
    // required this.to,
  });
factory DiscountDto.fromjson(Map<String,dynamic> json){
  return DiscountDto(value: json['value'],
    // from: DateTime.parse(json['from']),
    // to: DateTime.parse(json['to']),
  );
}
// bool get isActive {
//   final now = DateTime.now();
//   return !now.isBefore(from) && !now.isAfter(to);
// }
}
