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
    print('[디버그] toFormData() 진입');
    print('mainImage: $mainImage');
    final Map<String, dynamic> data = {
      'category': category,
      'title': title,
      'content': content,
      if (productId != null) 'productId': productId,
    };

    if (mainImage != null && mainImage!.isNotEmpty) {
      final fileName = path.basename(mainImage!);

      data['images.main'] = await MultipartFile.fromFile(
        mainImage!,
        filename: fileName,
      );
    }

    return FormData.fromMap(data);
  }

}
