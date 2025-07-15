import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../category/category_data_select_viewmodel.dart';


class ProductRegisterViewModel extends ChangeNotifier {
  final Dio _dio;
  ProductRegisterViewModel(this._dio);

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ✅ 선택된 옵션
  final List<String> selectedSizes = [];
  final List<String> selectedColors = [];

  void toggleSize(String size) {
    if (selectedSizes.contains(size)) {
      selectedSizes.remove(size);
    } else {
      selectedSizes.add(size);
    }
    notifyListeners();
  }

  void toggleColor(String color) {
    if (selectedColors.contains(color)) {
      selectedColors.remove(color);
    } else {
      selectedColors.add(color);
    }
    notifyListeners();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = pickedFile;
      notifyListeners();
    }
  }

  Future<bool> registerAndNotify(BuildContext context) async {
    final categoryVm = context.read<CategoryDataSelectViewmodel>();
    final selectedCategoryId = categoryVm.selectedSubCategory?.id;

    if (nameController.text.isEmpty || priceController.text.isEmpty || selectedCategoryId == null) {
      debugPrint('입력값 또는 카테고리 선택이 누락되었습니다.');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    const path = '/api/seller/products';

    final discountRate = int.tryParse(discountController.text.trim()) ?? 0;

    final options = {
      'size': selectedSizes,
      'color': selectedColors,
    };

    final formData = FormData.fromMap({
      'name': nameController.text,
      'price': int.tryParse(priceController.text) ?? 0,
      'description': descController.text,
      'categoryId': selectedCategoryId,
      'category': categoryVm.selectedSubCategory?.name,
      'options': jsonEncode(options),
      'discount': jsonEncode({"rate": discountRate}),
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        await context.read<ProductViewModel>().fetchProducts();
        _clearInputs();
        return true;
      }
      return false;
    } on DioException catch (e) {
      debugPrint('상품 등록 중 dio 오류: ${e.response?.data}');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clearInputs() {
    nameController.clear();
    descController.clear();
    priceController.clear();
    discountController.clear();
    selectedSizes.clear();
    selectedColors.clear();
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
