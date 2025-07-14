import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/model/entity/response/gender_category_id.dart';
import 'package:look_talk/model/repository/category_repository.dart';

class CategoryDataSelectViewmodel with ChangeNotifier {
  final CategoryRepository repository;

  CategoryDataSelectViewmodel({required this.repository}) {
    fetchMainCategories(GenderType.male);
  }

  GenderType _selectedGender = GenderType.male;
  BringSubCategoryResponse? _selectedMainCategory;
  BringSubCategoryResponse? _selectedSubCategory;
  List<BringSubCategoryResponse> _mainCategories = [];
  List<BringSubCategoryResponse> _subCategories = [];
  bool _isLoading = false;

  GenderType get selectedGender => _selectedGender;
  BringSubCategoryResponse? get selectedMainCategory => _selectedMainCategory;
  BringSubCategoryResponse? get selectedSubCategory => _selectedSubCategory;
  List<BringSubCategoryResponse> get categories => _mainCategories;
  List<BringSubCategoryResponse> get subCategories => _subCategories;
  bool get isLoading => _isLoading;

  //  상품 등록 선택된 서브 카테고리의 ID와 이름
  String? get selectedCategoryId => _selectedSubCategory?.id;
  String? get selectedCategoryName => _selectedSubCategory?.name;

  Future<void> fetchMainCategories(GenderType gender) async {
    _selectedGender = gender;
    _selectedMainCategory = null;
    _selectedSubCategory = null;
    _isLoading = true;
    notifyListeners();

    final parentId = GenderCategoryId.id[gender]!;
    try {
      final result = await repository.categoryResult(parentId);
      _mainCategories = result;
    } catch (e) {
      print('카테고리 로드 중 에러 발생 $e');
      _mainCategories = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectMainCategory(BringSubCategoryResponse category) async {
    _selectedMainCategory = category;
    _selectedSubCategory = null;
    await fetchSubCategories(category.id);
  }

  void changeSubCategory(BringSubCategoryResponse category) {
    _selectedSubCategory = category;
    notifyListeners();
  }

  void changeMainCategory(BringSubCategoryResponse category) {
    _selectedMainCategory = category;
    notifyListeners();
  }

  Future<void> fetchSubCategories(String parentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await repository.categoryResult(parentId);
      _subCategories = result;
    } catch (e) {
      print('서브 카테고리 로드 실패: $e');
      _subCategories = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
