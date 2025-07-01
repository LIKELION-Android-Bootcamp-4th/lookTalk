import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/view_model/category/category_sub_data_select_viewmodel.dart';
import 'package:provider/provider.dart';

class SubCategory extends StatelessWidget {
  final String selectedSubCategory;
  final Function(String) onSelect;
  const SubCategory({
    required this.selectedSubCategory,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CategorySubDataSelectViewModel>(context);

    return Container(
      width: 243,
      color: Colors.white,
      child: ListView(
        children: viewModel.getSubCategories.map((sub) {
          final isSelected = selectedSubCategory == sub;

          return GestureDetector(
            onTap: () => onSelect(sub),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 53),
                    child: Text(
                      sub,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Spacer(),
                  Padding(padding: EdgeInsets.only(right: 30),
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                  ),
                  )

                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
