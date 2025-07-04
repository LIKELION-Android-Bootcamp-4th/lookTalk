import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/model/category_dummydata.dart';

class ProductRegisterViewModel extends ChangeNotifier {
  String? selectedGender;
  CategoryEntity? selectedTopCategoryEntity;
  String? selectedSubCategory;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  List<CategoryEntity> get availableCategories {
    if (selectedGender == '남성') return manCategory;
    if (selectedGender == '여성') return womanCategory;
    return [];
  }

  List<String> get topCategoryNames => availableCategories.map((e) => e.mainCategory).toList();

  List<String> get subCategoryNames {
    if (selectedTopCategoryEntity != null) {
      return selectedTopCategoryEntity!.subCategory;
    }
    return [];
  }

  void setGender(String? gender) {
    if (selectedGender != gender) {
      selectedGender = gender;
      selectedTopCategoryEntity = null;
      selectedSubCategory = null;
      notifyListeners();
    }
  }

  void setTopCategory(String? categoryName) {
    selectedTopCategoryEntity = availableCategories.firstWhere(
          (cat) => cat.mainCategory == categoryName,
      orElse: () => CategoryEntity(id: 0, mainCategory: '', subCategory: []),
    );

    if (selectedTopCategoryEntity!.mainCategory.isEmpty) {
      selectedTopCategoryEntity = null;
    }
  }
  void setSubCategory(String? subCategoryName) {
    selectedSubCategory = subCategoryName;
    notifyListeners();
  }

  void submitProduct() {
    print('상품명: ${nameController.text}');
    print('설명: ${descController.text}');
    print('성별: $selectedGender');
    print('카테고리: ${selectedTopCategoryEntity?.mainCategory} / $selectedSubCategory');
    print('가격: ${priceController.text}');
    print('할인율: ${discountController.text}');
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }
}
