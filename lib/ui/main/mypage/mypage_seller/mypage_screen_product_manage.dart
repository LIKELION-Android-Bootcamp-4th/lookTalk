import 'package:flutter/material.dart';
import 'package:look_talk/ui/main/mypage/mypage_seller/product_screen_edit.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:look_talk/ui/main/mypage/mypage_seller/mypage_screen_product_register.dart';
import 'package:look_talk/ui/main/mypage/mypage_seller/product_screen_edit.dart';
import 'package:look_talk/model/entity/product_entity.dart';

import '../../../../view_model/product/product_register_viewmodel.dart';


class MyPageProductManageScreen extends StatelessWidget {
  const MyPageProductManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => ProductRegisterViewModel()),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('상품 조회 / 등록'),
            bottom: TabBar(
              tabs: [
                Tab(text: '상품 조회'),
                Tab(text: '상품 등록'),
              ],
            ),
          ),
          body: TabBarView(
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
    final productList = context.watch<ProductViewModel>().products;

    return ListView.separated(
      itemCount: productList.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = productList[index];
        return ListTile(
          title: Text(product.name),
          trailing: Text(product.code),
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
    );
  }
}
