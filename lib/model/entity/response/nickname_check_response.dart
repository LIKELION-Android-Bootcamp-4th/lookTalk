// class NicknameCheckResponse {
//   final bool available;
//   final String? nickname;
//   final String message;
//
//   NicknameCheckResponse({
//     required this.available,
//     required this.nickname,
//     required this.message,
//   });
//
//   factory NicknameCheckResponse.fromJson(Map<String, dynamic> json) {
//     return NicknameCheckResponse(
//       available: json['available'] as bool,
//       nickname: json['nickname'] as String?,
//       message: json['message'] as String,
//     );
//   }
// }

class CheckNameResponse {
  final bool available;
  final String? nickname;
  final String? message;

  CheckNameResponse({
    required this.available,
    this.nickname,
    required this.message,
  });

  factory CheckNameResponse.fromJson(Map<String, dynamic> json) {
    // final rawData = json['data'];
    //
    // if (rawData == null || rawData is! Map<String, dynamic>) {
    //   throw Exception("Invalid or missing 'data' field in response.");
    // }
    //
    // return CheckNameResponse(
    //   available: rawData['available'] as bool,
    //   nickname: rawData['nickname'] as String?,
    //   message: rawData['message'] as String?,
    // );
    return CheckNameResponse(
      available: json['available'] as bool,
      nickname: json['nickname'] ?? json['storeName'],
      message: json['message'] as String? ?? '',
    );
  }
}


