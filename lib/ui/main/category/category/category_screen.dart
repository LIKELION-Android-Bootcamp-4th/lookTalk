import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/ui/main/category/category/gender_toggle.dart';
import 'package:look_talk/ui/main/category/category/main_category.dart';
import 'package:look_talk/ui/main/category/category/sub_category.dart';
import 'package:look_talk/ui/main/category/categorydetail/category_detail_screen.dart';
import 'package:look_talk/view_model/category/category_data_select_viewmodel.dart';
import 'package:look_talk/view_model/category/category_sub_data_select_viewmodel.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryDataSelectViewmodel()),
        ChangeNotifierProvider(create: (_) => CategorySubDataSelectViewModel())
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("카테고리"),
          titleTextStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart_outlined)),
                ],
              ),
            ),
          ],
        ),
        body: Consumer2<CategoryDataSelectViewmodel, CategorySubDataSelectViewModel>(
          builder: (context, mainViewmodel, subViewmodel, child) {
            final mainCategories = mainViewmodel.categories;
            final subCategories = mainViewmodel.categories
                .firstWhere(
                  (category) => category.mainCategory == subViewmodel.selectedMainCategory,
              orElse: () => CategoryEntity(id: 0, mainCategory: '', subCategory: []),
            )
                .subCategory;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: GenderToggle(
                    selectedGender: mainViewmodel.selectedGender,
                    onSelectedButton: (gender) {
                      mainViewmodel.changeGender(gender);
                      subViewmodel.changeMainCategory(gender);
                    },
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      MainCategory(
                        selectedMainCategory: subViewmodel.selectedMainCategory,
                        onSelect: (category) {
                          setState(() {
                            subViewmodel.changeMainCategory(category);
                          });
                        },
                      ),
                      SubCategory(
                        selectedSubCategory: subViewmodel.selectedSubCategory,
                        subCategories: subCategories,
                        onSelect: (category) {
                          subViewmodel.changeSubCategory(category);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryDetailScreen(
                                mainCategory: subViewmodel.selectedMainCategory,
                                subCategory: category,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
