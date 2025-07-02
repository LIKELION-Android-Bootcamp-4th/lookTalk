
import 'package:flutter/material.dart';

class CategorySelectViewmodel extends ChangeNotifier{
  //중복 기능이어서 삭제 후 플로우 재 설정
  String _selectedGender = "남자";
  String get selectedGender => _selectedGender;

  void changeGender(String gender){
    _selectedGender = gender;
    notifyListeners();
  }
}