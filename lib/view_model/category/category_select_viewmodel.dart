
import 'package:flutter/material.dart';

class CategorySelectViewmodel extends ChangeNotifier{
  //카테고리 중 성별 전환 기능
  String _selectedGender = "남자";
  String get selectedGender => _selectedGender;

  void changeGender(String gender){
    _selectedGender = gender;
    notifyListeners();
  }
}