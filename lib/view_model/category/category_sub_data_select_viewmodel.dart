import 'package:flutter/material.dart';
import 'package:look_talk/model/category_dummydata.dart';
import 'package:look_talk/model/entity/category_entity.dart';

class CategorySubDataSelectViewModel with ChangeNotifier {
  String _selectedGender = "남자";
  List<CategoryEntity> _categories = [];
  String _selectedMainCategory = '';
  String _selectedSubCategory = '';

  List<CategoryEntity> get categories => _categories;
  String get selectedMainCategory => selectedMainCategory;
  String get selectedSubCategory => selectedSubCategory;

  List<String> get getSubCategories {
    final mainCategory = _categories.firstWhere((category) =>
      category.mainCategory == _selectedMainCategory,
      orElse: () => CategoryEntity(id: 0, mainCategory: '', subCategory: []),
    );
        return mainCategory.subCategory;
  }

  void getData(String gender) {
    _selectedGender = gender;
    _categories = gender == "남자" ? manCategory : womanCategory;
    _selectedMainCategory = selectedMainCategory.isEmpty ? ' ' : _categories.first.mainCategory;
    _selectedSubCategory = '';
    notifyListeners();
  }

  void changeMainCategory(String mainCategory){
    _selectedMainCategory = mainCategory;
    _selectedSubCategory = '';
    notifyListeners();
  }
  void changeSubCategory(String subCategory){
    _selectedSubCategory = subCategory;
    notifyListeners();
  }
}