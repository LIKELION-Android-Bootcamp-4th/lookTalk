// class NicknameCheckRequest {
//   final String nickname;
//
//   NicknameCheckRequest({required this.nickname});
//
//   Map<String, dynamic> toQuery() {
//     return {
//       'nickname': nickname,
//     };
//   }
// }
enum CheckNameType {
  nickname,
  storeName;

  String get queryKey {
    switch (this) {
      case CheckNameType.nickname:
        return 'nickname';
      case CheckNameType.storeName:
        return 'storeName';
    }
  }
}

class CheckNameRequest {
  final CheckNameType type;
  final String value;

  CheckNameRequest({required this.type, required this.value});

  Map<String, dynamic> toQuery() {
    return {type.queryKey: value};
  }
}

