import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/view_model/home/home_category_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../common/const/colors.dart';

class HomeCategory extends StatelessWidget {
  const HomeCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<HomeCategoryViewModel>(
      builder: (context, viewModel, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: viewModel.categoryNames.map((categoryName) {
              final isSelected = viewModel.selectedCategoryName == categoryName;

              return GestureDetector(
                onTap: () => viewModel.changeHomeCategory(categoryName),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.all(5),
                  width: screenWidth * 0.16,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.iconGrey,
                      width: 1.3,
                    ),
                    color: isSelected ? AppColors.btnPrimary : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categoryName,
                    style: isSelected
                        ? context.bodyBold.copyWith(color: AppColors.white)
                        : context.bodyBold.copyWith(color: AppColors.darkGrey),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
