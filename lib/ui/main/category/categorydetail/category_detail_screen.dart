import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_home_search_cart.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/main/category/categorydetail/detail_listview.dart';
import 'package:look_talk/view_model/category/category_detail/detail_listview_viewmodel.dart';
import 'package:provider/provider.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailListviewViewmodel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBarHomeSearchCart(title: viewModel.mainCategory.name,),
          body: Column(
            children: [
              DetailListview(viewModel: viewModel),
              gap16,
              viewModel.productList.isEmpty
                  ? const Center(child: Text("찾으시는 제품이 없습니다."))
                  : Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: viewModel.productList.length,
                  itemBuilder: (context, index) {
                    final product = viewModel.productList[index];
                    final imageUrl = product.images.isNotEmpty ? product.images.first : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageUrl != null
                            ? Image.network(imageUrl, width: 100, height: 103, fit: BoxFit.cover)
                            : Icon(Icons.image, size: 100, color: Colors.grey),
                        gap8,
                        Text(product.storeName ?? '', style: context.h1.copyWith(fontSize: 12)),
                        gap4,
                        Text(product.name, style: context.bodyBold.copyWith(fontSize: 10)),
                        const SizedBox(height: 4),
                        Text("${product.price}원", style: context.h1.copyWith(fontSize: 14)),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}