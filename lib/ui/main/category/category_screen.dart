import 'package:flutter/material.dart';
import 'package:look_talk/ui/main/category/gender_toggle.dart';
import 'package:look_talk/ui/main/category/main_category.dart';
import 'package:look_talk/ui/main/category/sub_category.dart';
import 'package:look_talk/view_model/category/category_data_select_viewmodel.dart';
import 'package:look_talk/view_model/category/category_select_viewmodel.dart';
import 'package:look_talk/view_model/category/category_sub_data_select_viewmodel.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedMainCategory = '';
  String selectedSubCategory = '';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategorySelectViewmodel()),
        ChangeNotifierProvider(create: (_) => CategoryDataSelectViewmodel()),
        ChangeNotifierProvider(create: (_) => CategorySubDataSelectViewModel()),
      ],
      child: Consumer2<CategorySelectViewmodel, CategoryDataSelectViewmodel>(
        builder: (context, selectedViewmodel, dataViewModel, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: GenderToggle(
                  selectedGender: selectedViewmodel.selectedGender,
                  onSelectedButton: (gender) {
                    selectedViewmodel.changeGender(gender);
                    dataViewModel.getData(gender);
                    setState(() {
                      selectedMainCategory = '상의';
                    });
                  },
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    MainCategory(
                      selectedMainCategory: selectedMainCategory,
                      onSelect: (category) {
                        setState(() {
                          selectedMainCategory = category;
                        });
                        Provider.of<CategorySubDataSelectViewModel>(context, listen: false)
                            .changeMainCategory(category);
                      },
                    ),
                    SubCategory(
                      selectedSubCategory: selectedSubCategory,
                      onSelect: (category) {
                        setState(() {
                          selectedSubCategory = category;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
