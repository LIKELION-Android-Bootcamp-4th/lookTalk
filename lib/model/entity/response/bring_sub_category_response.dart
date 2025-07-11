class BringSubCategoryResponse{
  final String id;
  final String name;
  final List<BringSubCategoryResponse> children;

  BringSubCategoryResponse({required this.id, required this.name,required this.children});

  factory BringSubCategoryResponse.fromJson(Map<String,dynamic> json){
    return BringSubCategoryResponse(
        id: json['id'],
        name: json['name'],
        children:  (json['children'] as List<dynamic>?)
            ?.map((e) => BringSubCategoryResponse.fromJson(e))
            .toList() ??
            [],
    );

  }

}