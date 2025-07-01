import 'package:flutter/material.dart';
import 'package:look_talk/model/category_dummydata.dart';
import 'package:look_talk/model/entity/category_entity.dart';

class CategoryDataSelectViewmodel with ChangeNotifier {
  List<CategoryEntity> _categories = [];
  List<CategoryEntity> get categories => _categories;

  void getData(String gender) {
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