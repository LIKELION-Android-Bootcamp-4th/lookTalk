
import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/model/entity/response/category_detail_response.dart';
import 'package:look_talk/model/repository/category_detail_repository.dart';
import 'package:look_talk/ui/main/category/category/sub_category.dart';

class DetailListviewViewmodel with ChangeNotifier{
  final CategoryDetailRepository repository;
  final List<BringSubCategoryResponse> subCategories;
  BringSubCategoryResponse? selectedCategory;// 선택 카테고리 이거 사용하면 됨.
  List<CategoryDetailResponse> _productList = [];
  BringSubCategoryResponse mainCategory;

  List<CategoryDetailResponse> get productList => _productList;



  DetailListviewViewmodel({
    required this.repository,
    required this.subCategories,
    required BringSubCategoryResponse initialSubCategory,
    required this.mainCategory,
}){
    mainCategory = mainCategory;
    selectedCategory = initialSubCategory;
    fetchCommunityList(initialSubCategory.id);
  }
  bool isSelected(BringSubCategoryResponse category){
    return selectedCategory == category;
  }

  void changeSubCategory(BringSubCategoryResponse subCategory){
    if(selectedCategory == subCategory){
      return;
    }
    selectedCategory = subCategory;
    fetchCommunityList(subCategory.id);
    notifyListeners();
  }

  Future<void> fetchCommunityList(String categoryId) async {
    try {
      final result = await repository.categoryResultDetail(categoryId);
      _productList = result;
      notifyListeners();
    }catch (e){
      print("카테고리 상세 가져오기 실패 {$e}");
      _productList = [];
      notifyListeners();
    }
  }


}