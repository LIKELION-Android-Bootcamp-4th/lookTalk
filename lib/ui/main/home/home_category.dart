import 'package:flutter/material.dart';
import 'package:look_talk/view_model/home/home_category_viewmodel.dart';
import 'package:provider/provider.dart';

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
            children: viewModel.homeCategory.map((category) {
              final isSelected = viewModel.selectedCategory == category;

              return GestureDetector(
                onTap: () => viewModel.changeHomeCategory(category),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  margin: EdgeInsets.all(5),
                  width: screenWidth*0.16,

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,

                    ),
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(20),

                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontFamily: "NanumSquareRoundEB",
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 12,
                    ),
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
