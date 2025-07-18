import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/view_model/category/category_detail/detail_listview_viewmodel.dart';

class DetailListview extends StatelessWidget {
  final DetailListviewViewmodel viewModel;

  const DetailListview({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.subCategories.isEmpty) {
      return const Center(child: Text("설정이 잘못되었습니다."));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: viewModel.subCategories.map((category) {
          return GestureDetector(
            onTap: () => viewModel.changeSubCategory(category),
            child: Container(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                category.name,
                style: viewModel.isSelected(category)
                    ? context.bodyBold.copyWith(
                        color: Colors.blue,
                        fontSize: 20,
                      )
                    : context.body.copyWith(color: Colors.grey, fontSize: 20),

                // TextStyle(
                //
                //   fontSize: 20,
                //   color: viewModel.isSelected(category) ? Colors.blue : Colors.grey,
                // ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
