import 'package:flutter/material.dart';
import 'package:look_talk/model/category_dummydata.dart';
import 'package:look_talk/model/entity/category_entity.dart';

class CategoryDataSelectViewmodel with ChangeNotifier {

  String _selectedGender = '남자';
  List<CategoryEntity> _categories = manCategory;

  String get selectedGender => _selectedGender;
  List<CategoryEntity> get categories => _categories;

  void changeGender(String gender) {
    _selectedGender = gender;

    if( gender == '남자'){
      _categories = manCategory;
    }else if (gender == '여자') {
      _categories = womanCategory;
    } else {
      _categories = [];
    }

    notifyListeners();
  }

}