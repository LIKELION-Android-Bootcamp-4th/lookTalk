import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:look_talk/view_model/product/product_viewmodel.dart';
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

  XFile? _contentImage;
  XFile? get contentImage => _contentImage;

  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<String> selectedSizes = [];
  final List<String> selectedColors = [];

  final Map<String, TextEditingController> stockControllers = {};

  TextEditingController getStockController(String key) {
    return stockControllers.putIfAbsent(key, () => TextEditingController(text: '999'));
  }

  void updateStockControllers() {
    stockControllers.clear();
    for (final color in selectedColors) {
      for (final size in selectedSizes) {
        final key = '${color}_${size}';
        stockControllers.putIfAbsent(key, () => TextEditingController(text: '999'));
      }
    }
    notifyListeners();
  }

  void toggleSize(String size) {
    if (selectedSizes.contains(size)) {
      selectedSizes.remove(size);
    } else {
      selectedSizes.add(size);
    }
    updateStockControllers();
  }

  void toggleColor(String color) {
    if (selectedColors.contains(color)) {
      selectedColors.remove(color);
    } else {
      selectedColors.add(color);
    }
    updateStockControllers();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = pickedFile;
      notifyListeners();
    }
  }

  Future<void> pickContentImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _contentImage = pickedFile;
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

    final Map<String, int> stockMap = {};
    for (final entry in stockControllers.entries) {
      stockMap[entry.key] = int.tryParse(entry.value.text.trim()) ?? 0;
    }

    final totalStock = stockMap.values.fold(0, (prev, curr) => prev + curr);

    final formData = FormData.fromMap({
      'name': nameController.text,
      'price': int.tryParse(priceController.text) ?? 0,
      'description': descController.text,
      'categoryId': selectedCategoryId,
      'category': categoryVm.selectedSubCategory?.name,
      'options': jsonEncode(options),
      'discount': jsonEncode({"rate": discountRate}),
      'stock': totalStock,
      'attributes': jsonEncode(stockMap),
    });

    if (_imageFile != null) {
      final fileName = _imageFile!.path.split('/').last;
      formData.files.add(MapEntry(
        'thumbnailImage',
        await MultipartFile.fromFile(_imageFile!.path, filename: fileName),
      ));
    }

    if (_contentImage != null) {
      final fileName = _contentImage!.path.split('/').last;
      formData.files.add(MapEntry(
        'contentImage',
        await MultipartFile.fromFile(_contentImage!.path, filename: fileName),
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
    stockControllers.clear();
    _imageFile = null;
    _contentImage = null; // ⬅️ 초기화
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    discountController.dispose();
    for (final controller in stockControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
