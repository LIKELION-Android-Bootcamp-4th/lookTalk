import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class PostCreateRequest {
  final String category;
  final String title;
  final String content;
  final String? productId;
  final String? mainImage;

  PostCreateRequest({
    required this.category,
    required this.title,
    required this.content,
    this.productId,
    this.mainImage,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'title': title,
    'content': content,
    if (productId != null) 'productId': productId,
    if (mainImage != null)
      'images': {
        'main': mainImage,
      },
  };

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({
      'title': title,
      'content': content,
      'category': category,
      if (productId != null) 'productId': productId,
    });

    if (mainImage != null && mainImage!.isNotEmpty) {
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(mainImage!),
      ));
    }

    return formData;
  }

}
