import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/ui/main/community/communication_product_registration/product_history.dart';
import 'package:look_talk/ui/main/community/communication_product_registration/product_search.dart';
import 'package:provider/provider.dart';

import '../../../../core/extension/text_style_extension.dart';
import '../../../../view_model/community/community_product_tab_view_model.dart';
import '../../../../view_model/community/selected_product_view_model.dart';
import '../../../common/component/common_snack_bar.dart';
import '../../../common/const/colors.dart';

class ProductRegistrationScreen extends StatelessWidget {
  const ProductRegistrationScreen({super.key});

  static const List<Tab> _tabs = [Tab(text: "나의 구매내역"), Tab(text: "검색하기")];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              context.read<CommunityProductTabViewModel>().setTabIndex(
                tabController.index,
              );
            }
          });

          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildTabViews(context),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("상품 등록"),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: GestureDetector(
            onTap: () {
              final selectedProduct = context
                  .read<SelectedProductViewModel>()
                  .selectedProduct;

              if (selectedProduct == null) {
                CommonSnackBar.show(context, message: '상품을 선택해주세요.');
                return;
              }

              context.pop();
              //context.push('/community/write', extra: selectedProduct);
            },
            child: const Text("다음"),
          ),
        ),
      ],
      bottom: TabBar(
        tabs: _tabs,
        labelStyle: context.bodyBold,
        unselectedLabelStyle: context.bodyBold,
        labelColor: AppColors.black,
        unselectedLabelColor: AppColors.textGrey,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.black, width: 3),
          insets: EdgeInsets.symmetric(horizontal: 20),
        ),
        indicatorColor: AppColors.black,
        indicatorWeight: 3.0,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  Widget _buildTabViews(BuildContext context) {
    return const TabBarView(
      children: [CommunityProductHistory(), CommunityProductSearch()],
    );
  }
}
