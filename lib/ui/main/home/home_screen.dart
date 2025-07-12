import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/main/home/home_category.dart';
import 'package:look_talk/view_model/home/home_category_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeCategoryViewModel>();
    return Scaffold(
        appBar: AppBarSearchCart(leading: Image.asset('assets/images/logo.png',)),

        body: Column(
          children: [
            HomeCategory(),
            Expanded(
                child:
                viewModel.productList.isEmpty
                    ? Center(child: Text("찾으시는 제품이 없습니다."))
                    : GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: viewModel.productList.length,
                  itemBuilder: (context, index) {
                    final product = viewModel.productList[index];
                    final imageUrl = product.thumbnailImage;
                    final isValidImage = imageUrl != null && imageUrl.trim().isNotEmpty;


                    return  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isValidImage
                            ? Image.network(
                          imageUrl!,
                          width: 100,
                          height: 103,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 100, color: Colors.grey),
                        )
                            : Icon(Icons.image, size: 100, color: Colors.grey),

                        gap8,
                        Text(product.storeName ?? '', style: context.h1.copyWith(fontSize: 12),),
                        gap4,
                        Text(product.name, style: context.bodyBold.copyWith(fontSize: 10), ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            if (product.discount != null) ...[
                              // if (product.discount?.isActive == true) ...[
                              Text(
                                "${product.discount!.value}% ",
                                style: context.bodyBold.copyWith(fontSize: 12, color: Colors.red),
                              ),
                              gapW4,
                              Text(
                                "${(product.price * (100 - product.discount!.value) ~/ 100)}원",
                                style: context.h1.copyWith(fontSize: 14),
                              ),
                            ] else ...[
                              Text(
                                "${product.price}원",
                                style: context.h1.copyWith(fontSize: 14),
                              ),
                            ],
                          ],
                        )

                      ],
                    );
                  },
                ),
            )
          ],
        ),
    );
  }
}