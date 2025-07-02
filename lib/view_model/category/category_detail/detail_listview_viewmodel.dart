
import 'package:flutter/material.dart';

class DetailListviewViewmodel with ChangeNotifier{

  final List<String> subCategories;
  String selectedCategory = "";

  DetailListviewViewmodel({
    required this.subCategories,
    required String initialSubCategory,
}){
    selectedCategory = initialSubCategory;
  }
  bool isSelected(String category){
    return selectedCategory == category;
  }

  void changeSubCategory(String subCategory){
    if(selectedCategory == subCategory){
      return;
    }
    selectedCategory = subCategory;
    notifyListeners();
  }

}