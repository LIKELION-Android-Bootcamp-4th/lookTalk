import 'package:flutter/material.dart';
// api 연동하면서 필요 없어 사용 안함.
class CategorySubDataSelectViewModel with ChangeNotifier {
  String _selectedMainCategory = '';
  String _selectedSubCategory = '';
  List<String> _subCategories = [];
  List<String> get subCategories => _subCategories;
  String get selectedMainCategory => _selectedMainCategory;
  String get selectedSubCategory => _selectedSubCategory;

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