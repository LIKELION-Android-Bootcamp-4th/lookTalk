import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/model/category_dummydata.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../model/entity/product_entity.dart';

class ProductRegisterViewModel extends ChangeNotifier {
  final Dio _dio;
  ProductRegisterViewModel(this._dio);

  String? selectedGender;
  CategoryEntity? selectedTopCategoryEntity;
  String? selectedSubCategory;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  final ImagePicker _picker = ImagePicker();


  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = pickedFile;
      notifyListeners();
    }
  }

  Future<bool> registerProduct(BuildContext context) async {
    final success = await _submitProductAsSeller();

    if (success && context.mounted) {
      await context.read<ProductViewModel>().fetchProducts();
      _clearInputs();
      return true;
    }
    return false;
  }

  Future<bool> _submitProductAsSeller() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      debugPrint('상품명과 가격은 필수입니다.');
      return false;
    }
    if (_imageFile == null) {
      debugPrint('썸네일 이미지는 필수입니다.');
      return false;
    }

    // 2. API 경로 지정
    const path = '/api/seller/products';

    final formData = FormData.fromMap({
      'name': nameController.text,
      'price': int.tryParse(priceController.text) ?? 0,
      'description': descController.text,
      'category': selectedSubCategory,
      'stock': 100,
      'attributes': jsonEncode({"brand": "LookTalk"}),
      'options': jsonEncode([]),
      'discount': jsonEncode({"type": "percentage", "value": int.tryParse(discountController.text) ?? 0}),
    });

    final fileName = _imageFile!.path.split('/').last;
    formData.files.add(MapEntry(
      'thumbnailImage',
      await MultipartFile.fromFile(_imageFile!.path, filename: fileName),
    ));

    debugPrint('--- 상품 등록 요청 ---');
    debugPrint('Path: $path');

    try {
      final response = await _dio.post(path, data: formData);

      debugPrint('응답 코드: ${response.statusCode}');
      debugPrint('응답 내용: ${response.data}');

      return response.statusCode == 201 || response.statusCode == 200;

    } on DioException catch (e) {
      debugPrint('상품 등록 중 dio 오류: ${e.response?.data}');
      return false;
    }
  }

  void setGender(String? gender) {
    selectedGender = gender;
    selectedTopCategoryEntity = null;
    selectedSubCategory = null;
    notifyListeners();
  }
  void setTopCategory(String? category) {
    final list = selectedGender == '남성' ? manCategory : womanCategory;
    selectedTopCategoryEntity = list.firstWhere(
          (c) => c.mainCategory == category,
      orElse: () => CategoryEntity(id: -1, mainCategory: '', subCategory: []),
    );
    selectedSubCategory = null;
    notifyListeners();
  }
  void setSubCategory(String? subCategory) {
    selectedSubCategory = subCategory;
    notifyListeners();
  }
  List<String> get topCategoryNames {
    if (selectedGender == null) return [];
    final list = selectedGender == '남성' ? manCategory : womanCategory;
    return list.map((e) => e.mainCategory).toList();
  }
  List<String> get subCategoryNames {
    return selectedTopCategoryEntity?.subCategory ?? [];
  }
  void _clearInputs() {
    nameController.clear();
    descController.clear();
    priceController.clear();
    discountController.clear();
    selectedGender = null;
    selectedTopCategoryEntity = null;
    selectedSubCategory = null;
    _imageFile = null;
    notifyListeners();
  }
  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }
}
