import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';

class MyPageProductManageScreen extends StatelessWidget {
  const MyPageProductManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel(),
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
              _ProductRegisterTab(),
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
    final productList = context.watch<ProductViewModel>().products;

    return ListView.separated(
      itemCount: productList.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = productList[index];
        return ListTile(
          title: Text(product.name),
          trailing: Text(product.code),
        );
      },
    );
  }
}

class _ProductRegisterTab extends StatelessWidget {
  const _ProductRegisterTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('상품 등록 화면'),
    );
  }
}
