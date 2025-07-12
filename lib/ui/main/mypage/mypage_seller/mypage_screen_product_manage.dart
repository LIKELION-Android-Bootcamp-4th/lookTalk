import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:look_talk/ui/main/mypage/mypage_seller/mypage_screen_product_register.dart';
import 'package:look_talk/ui/main/mypage/mypage_seller/product_screen_edit.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/view_model/viewmodel_provider.dart'; // ✅ 이거 꼭 필요

class MyPageProductManageScreen extends StatelessWidget {
  const MyPageProductManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => provideProductViewModel()..fetchProducts(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('상품 조회 / 등록'),
            bottom: const TabBar(
              tabs: [
                Tab(text: '상품 조회'),
                Tab(text: '상품 등록'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              _ProductListTab(),
              ProductRegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductListTab extends StatelessWidget {
  const _ProductListTab();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.products.isEmpty) {
      return const Center(child: Text('등록된 상품이 없습니다.'));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ProductViewModel>().fetchProducts(),
      child: ListView.separated(
        itemCount: vm.products.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = vm.products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('상품 코드: ${product.productId}'),
                Text('카테고리: ${product.category}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductEditScreen(product: product),
                ),
              );
            },
          );

        },
      ),
    );
  }
}
