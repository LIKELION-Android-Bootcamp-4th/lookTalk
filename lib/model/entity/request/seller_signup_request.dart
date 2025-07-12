class SellerSignupRequest {
  final String name;
  final String description;

  SellerSignupRequest({required this.name, required this.description});

  Map<String, dynamic> toJson(){
    return {
      'name' : name,
      'description' : description
    };
  }

}
