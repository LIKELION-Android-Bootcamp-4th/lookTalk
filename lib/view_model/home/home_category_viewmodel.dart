import 'package:flutter/material.dart';
import 'package:look_talk/model/category_dummydata.dart';

class HomeCategoryViewModel with ChangeNotifier{
  List<String> _homeCategory = homeCategoryData;
  String _selectedCategory = '전체';

  String get selectedCategory => _selectedCategory;
  List<String> get homeCategory => _homeCategory;


  void changeHomeCategory(String category) {
    if(_selectedCategory == category){
      return;
    }
    _selectedCategory = category;
    notifyListeners();
  }



}