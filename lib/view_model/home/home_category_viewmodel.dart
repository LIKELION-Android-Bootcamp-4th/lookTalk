import 'package:flutter/material.dart';
import 'package:look_talk/model/category_dummydata.dart';
import 'package:look_talk/model/entity/response/home_response.dart';
import 'package:look_talk/model/repository/home_repository.dart';

class HomeCategoryViewModel with ChangeNotifier{
  final HomeRepository _homeRepository;

  HomeCategoryViewModel(this._homeRepository){
    _initialize();
  }

  List<String> _homeCategory = homeCategoryData;
  String _selectedCategory = '전체';
  List<Home> _productList = [];

  String get selectedCategory => _selectedCategory;
  List<String> get homeCategory => _homeCategory;
  List<Home> get productList => _productList;

  Future<void> _initialize() async {
    await _homeRepository.init();
    await changeProductList(_selectedCategory);
  }

  void changeHomeCategory(String category) {
    if(_selectedCategory == category){
      return;
    }
    _selectedCategory = category;
    changeProductList(_selectedCategory);
    notifyListeners();
  }
  Future<void> changeProductList(String category) async{
    try {
      final products = await _homeRepository.fetchProduct(category);
      _productList = products;
      notifyListeners();
    }catch (e){
      print('제품 불러오는 중 문제 발생 ${e}');
    }
  }



}