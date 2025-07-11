import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/entity/request/post_create_request.dart';
import '../../model/repository/post_create_repository.dart';

class PostCreateViewModel with ChangeNotifier {
  final PostCreateRepository repository;

  final Map<String, String> categoryMap = {
    '코디 질문': 'coord_question',
    '코디 추천': 'coord_recommend'
  };

  PostCreateViewModel(this.repository);

  String? _category;
  String? _title;
  String? _content;
  String? _productId;
  String? _mainImage;

  File? _imageFile;
  File? get imageFile => _imageFile;

  final ImagePicker _picker = ImagePicker();

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }
  void setTitle(String value) => _title = value;
  void setContent(String value) => _content = value;
  void setProductId(String id) => _productId = id;
  void setMainImage(String imageUrl) => _mainImage = imageUrl;

  bool get canSubmit {
    return _category?.isNotEmpty == true &&
        _title?.isNotEmpty == true &&
        _content?.isNotEmpty == true;
  }

  Future<String?> submitPost() async {
    if (!canSubmit) throw Exception("필수 항목을 모두 입력해주세요");

    final request = PostCreateRequest(
      category: _category!,
      title: _title!,
      content: _content!,
      productId: _productId,
      mainImage: _mainImage,
    );

    final result = await repository.createPost(request: request);

    if (result.success) {
      print('게시글 작성 성공: ${result.data?.id}');
      return result.data?.id;
    } else {
      throw Exception('작성 실패: ${result.message}');
    }
  }




  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1024,
    );

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1024,
    );

    if (photo != null) {
      _imageFile = File(photo.path);
      notifyListeners();
    }
  }

  void clearImage() {
    _imageFile = null;
    notifyListeners();
  }
}
