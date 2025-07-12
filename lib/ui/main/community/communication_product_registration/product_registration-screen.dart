import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/main/community/communication_product_registration/my_purchase_history_tab.dart';
import 'package:look_talk/ui/main/community/communication_product_registration/product_search.dart';

class ProductRegistrationScreen extends StatefulWidget {
  const ProductRegistrationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProdeuctRegistrationScreenState();
  }
  class _ProdeuctRegistrationScreenState extends State<ProductRegistrationScreen>
  with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = [
    Tab(text: "나의 구매내역",),
    Tab(text: "검색하기",)
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상품 등록"),
        centerTitle: true,
        actions: [
          Padding(
      padding: EdgeInsets.only(right: 30),
          child:
          GestureDetector(
            onTap:  (){},
            child:  Text("다음"),
          )
    ),
        ],
        bottom: TabBar(
                controller: _tabController,
                tabs: _tabs,
                labelStyle: context.bodyBold,
                labelColor: AppColors.black,
                unselectedLabelColor: AppColors.textGrey,
                unselectedLabelStyle: context.bodyBold,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: AppColors.black, width: 3),
                  insets: EdgeInsets.symmetric(horizontal: 20),
                ),
              indicatorColor: AppColors.black,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
            )
      ),
      body: Column(
        children: [
          Expanded(child: TabBarView(
              controller: _tabController,
            children: [
              MyPurchaseHistoryTab(),
              ProductSearch(),
            ],

          ))
        ],
      ),
    );
  }


  }

