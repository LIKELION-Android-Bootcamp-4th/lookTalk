import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_home_search_cart.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/main/category/categorydetail/detail_listview.dart';
import 'package:look_talk/view_model/category/category_detail/detail_listview_viewmodel.dart';
import 'package:provider/provider.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailListviewViewmodel>();
    final productList = viewModel.productList;

    return viewModel.isLoading
        ? CommonLoading()
        : Scaffold(
            appBar: AppBarHomeSearchCart(
              title: viewModel.mainCategory.name,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gap8,
                Image.asset('assets/images/ad.png', width: double.infinity, fit: BoxFit.fitWidth),
                gap24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: DetailListview(viewModel: viewModel),
                ),
                gap12,
                Expanded(
                  child: productList.isEmpty
                      ? const Center(child: Text("찾으시는 제품이 없습니다."))
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.6,
                              ),
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            final product = productList[index];
                            final imageUrl = product.thumbnailImage;
                            final isValidImage =
                                imageUrl != null && imageUrl.trim().isNotEmpty;

                            return GestureDetector(
                              onTap: () {
                                if (product != null) {
                                  context.push('/product/${product.id}');
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isValidImage
                                      ? Image.network(
                                          imageUrl!,
                                          width: 100,
                                          height: 103,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.broken_image,
                                                size: 100,
                                                color: Colors.grey,
                                              ),
                                        )
                                      : const Icon(
                                          Icons.image,
                                          size: 100,
                                          color: Colors.grey,
                                        ),
                                  gap8,
                                  Text(
                                    product.storeName ?? '',
                                    style: context.h1.copyWith(fontSize: 12),
                                  ),
                                  gap4,
                                  Text(
                                    product.name,
                                    style: context.bodyBold.copyWith(
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (product.discount != null &&
                                          product.discount!.value > 0) ...[
                                        Text(
                                          "${product.discount!.value}% ",
                                          style: context.bodyBold.copyWith(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                        gapW4,
                                        Text(
                                          '${formatPrice(
                                              product.price * (100 - product.discount!.value) ~/ 100
                                          )}원',
                                          style: context.h1.copyWith(fontSize: 14),
                                        ),
                                      ] else ...[
                                        Text(
                                          '${formatPrice(product.price)}원',
                                          style: context.h1.copyWith(fontSize: 14),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
  }
  String formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
    );
  }
}
