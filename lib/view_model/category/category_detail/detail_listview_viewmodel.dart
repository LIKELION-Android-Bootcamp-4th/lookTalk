
import 'package:flutter/material.dart';

class DetailListviewViewmodel with ChangeNotifier{
  final String mainCategory;
  final String gender;
  final List<String> subCategories;

  String selectedCategory = "";


  DetailListviewViewmodel({
    required this.mainCategory,
    required this.gender,
    required this.subCategories,
    required String initialSubCategory,
}){
    selectedCategory = initialSubCategory;
  }

  void changeSubCategory(String subCategory){
    if(selectedCategory == subCategory){
      return;
    }
    selectedCategory = subCategory;
    notifyListeners();
  }

}