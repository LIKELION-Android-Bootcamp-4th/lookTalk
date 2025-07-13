import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/model/category_dummydata.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductRegisterViewModel extends ChangeNotifier {
  final Dio _dio;
  ProductRegisterViewModel(this._dio);

  // --- 상태 변수, 컨트롤러 등 ---
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- 메서드들 ---

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = pickedFile;
      notifyListeners();
    }
  }

  /// 상품 등록 및 API 호출 후 목록 갱신
  Future<bool> registerAndNotify(BuildContext context) async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      debugPrint('상품명과 가격은 필수입니다.');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    const path = '/api/seller/products';

    final formData = FormData.fromMap({
      'name': nameController.text,
      'price': int.tryParse(priceController.text) ?? 0,
      'description': descController.text,
      'categoryId': selectedTopCategoryEntity?.id.toString(),   // 카테고리 ID 추가
      'category': selectedSubCategory,  // 카테고리 이름 추가
    });

    if (_imageFile != null) {
      final fileName = _imageFile!.path.split('/').last;
      formData.files.add(MapEntry(
        'thumbnailImage',
        await MultipartFile.fromFile(_imageFile!.path, filename: fileName),
      ));
    }

    try {
      final response = await _dio.post(path, data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // 등록 성공 시, 상품 목록을 새로고침합니다.
        await context.read<ProductViewModel>().fetchProducts();
        _clearInputs();
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      debugPrint('상품 등록 중 dio 오류: ${e.response?.data}');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
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
