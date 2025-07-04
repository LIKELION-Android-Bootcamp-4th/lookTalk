import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/model/category_dummydata.dart';
import 'package:look_talk/model/product_dummy.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../model/entity/product_entity.dart';

class ProductRegisterViewModel extends ChangeNotifier {
  String? selectedGender;
  CategoryEntity? selectedTopCategoryEntity;
  String? selectedSubCategory;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  void setGender(String? gender) {
    selectedGender = gender;
    selectedTopCategoryEntity = null;
    selectedSubCategory = null;
    notifyListeners();
  }

  void setTopCategory(String? category) {
    final list = selectedGender == '남성' ? manCategory : womanCategory;
    selectedTopCategoryEntity = list.firstWhere(
          (c) => c.mainCategory == category,
      orElse: () => CategoryEntity(id: -1, mainCategory: '', subCategory: []),
    );
    selectedSubCategory = null;
    notifyListeners();
  }

  void setSubCategory(String? subCategory) {
    selectedSubCategory = subCategory;
    notifyListeners();
  }

  List<String> get topCategoryNames {
    final list = selectedGender == '남성' ? manCategory : womanCategory;
    return list.map((e) => e.mainCategory).toList();
  }

  List<String> get subCategoryNames {
    return selectedTopCategoryEntity?.subCategory ?? [];
  }

  void registerAndNotify(BuildContext context) {
    final product = Product(
      name: nameController.text,
      code: 'P${DateTime
          .now()
          .millisecondsSinceEpoch}',
    );

    context.read<ProductViewModel>().addProduct(product);
    submitProduct();
  }

  void submitProduct() {
    debugPrint('상품명: ${nameController.text}');
    debugPrint('설명: ${descController.text}');
    debugPrint('성별: $selectedGender');
    debugPrint('카테고리: ${selectedTopCategoryEntity
        ?.mainCategory} / $selectedSubCategory');
    debugPrint('가격: ${priceController.text}');
    debugPrint('할인율: ${discountController.text}');
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