

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/ui/main/category/category/sub_category.dart';
import 'package:provider/provider.dart';

import '../../../../model/entity/response/bring_sub_category_response.dart';
import '../../../../view_model/category/category_data_select_viewmodel.dart';
import '../../../common/component/app_bar/app_bar_home_search_cart.dart';
import '../../../common/component/app_bar/app_bar_search_cart.dart';
import 'gender_toggle.dart';
import 'main_category.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarSearchCart(title: '카테고리',),
        body: Consumer<CategoryDataSelectViewmodel>(
          builder: (context, viewmodel, child) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: GenderToggle(
                    selectedGender: viewmodel.selectedGender,
                    onSelectedButton: (gender) {
                      viewmodel.fetchMainCategories(gender);
                    },
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                      MainCategory(
                        selectedMainCategory: viewmodel.selectedMainCategory ?? BringSubCategoryResponse(id: '', name: '', children: []),
                        onSelect: (category) {
                          setState(() {
                            viewmodel.changeMainCategory(category);
                            viewmodel.fetchSubCategories(category.id);
                          });
                        },
                      ),
                      ),

                      Expanded(
                        flex: 3, // flex로 비율 설정.
                          child:
                           viewmodel.selectedMainCategory != null
                              ? SubCategory(
                            selectedSubCategory: viewmodel.selectedSubCategory ?? BringSubCategoryResponse(id: '', name: '선택 없음', children: []),
                            subCategories: viewmodel.subCategories,
                            onSelect: (category) {
                              viewmodel.changeSubCategory(category);


                              context.pushNamed(
                                'categoryDetail',
                                extra: {
                                  'mainCategory' : viewmodel.selectedMainCategory,
                                  'subCategories' : viewmodel.subCategories,
                                  'selectedSubCategory' : viewmodel.selectedSubCategory,
                                }
                              );
                            },
                          )
                              : const SizedBox()
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
