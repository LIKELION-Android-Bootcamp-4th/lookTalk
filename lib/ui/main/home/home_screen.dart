import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/main/home/home_category.dart';
import 'package:look_talk/view_model/home/home_category_viewmodel.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/viewmodel_provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeCategoryViewModel()),
        ChangeNotifierProvider(create: (_) => provideProductViewModel()..fetchProducts()),
      ],
      child: Scaffold(
        appBar: AppBarSearchCart(
          leading: Image.asset('assets/images/logo.png'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeCategory(),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<ProductViewModel>(
                builder: (context, viewModel, _) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: viewModel.products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product = viewModel.products[index];
                      return GestureDetector(
                        onTap: () => context.go('/product/${product.productId}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('${product.finalPrice}원', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
