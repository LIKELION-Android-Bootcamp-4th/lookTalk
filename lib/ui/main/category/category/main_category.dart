import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/view_model/category/category_data_select_viewmodel.dart';
import 'package:look_talk/view_model/category/category_select_viewmodel.dart';
import 'package:provider/provider.dart';

class MainCategory extends StatelessWidget {
  final BringSubCategoryResponse selectedMainCategory;
  final Function(BringSubCategoryResponse) onSelect;
  const MainCategory({
    required this.selectedMainCategory,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CategoryDataSelectViewmodel>(context);

    return Container(
      width: 110,
      color: Colors.grey[200],
      child: ListView(
        children: viewModel.categories.map((BringSubCategoryResponse category) {
          final isSelected = selectedMainCategory == category;

          return GestureDetector(
            onTap: () => onSelect(category),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 16),
              color: isSelected ? Colors.white : Colors.grey[200],
              child: Text(
                category.name,
                style: TextStyle(color: Colors.black, fontWeight: isSelected ? FontWeight.w900: FontWeight.w600 ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}