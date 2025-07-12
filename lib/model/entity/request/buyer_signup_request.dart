class BuyerSignupRequest {
  final String nickName;
  final List<String> platformRoles;

  BuyerSignupRequest({
    required this.nickName,
  }) : platformRoles = ["buyer"];

  Map<String, dynamic> toJson() {
    return {
      'nickName': nickName,
      'platformRoles': platformRoles,
    };
  }
}
