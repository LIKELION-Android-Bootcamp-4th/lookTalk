import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/cancel_tab.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/filter_tab.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/order_tab.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/return_product_tab.dart';


class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<ManageProductScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> tabs = [
    Tab(text: '주문'),
    Tab(text: '반품'),
    Tab(text: '취소'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSearchCart(
        title: '주문/반품/취소',
        bottom: PreferredSize(preferredSize: const Size.fromHeight(100), child:
        Column(
          children: [
            FilterTab(),
            TabBar(
              controller: _tabController,
              tabs: tabs,
              labelStyle: context.bodyBold,
              labelColor: AppColors.black,
              unselectedLabelStyle: context.bodyBold,
              unselectedLabelColor: AppColors.textGrey,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.black, width: 3),
                insets: EdgeInsets.symmetric(horizontal: 20),
              ),
              indicatorColor: AppColors.black,
              indicatorWeight: 3.0,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ],
        )
        )

      ),
      body: Column(
        children: [
        Expanded(
          child:
          TabBarView(
            controller: _tabController,
            children: [
              OrderTab(),
              ReturnProductTab(),
              CancelTab(),
            ],
          ),
        ),
        ],

      )



    );
  }
}
