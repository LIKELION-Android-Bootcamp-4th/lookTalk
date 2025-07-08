import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/core/utils/auth_guard.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/main/community/community_my_tab.dart';
import 'package:look_talk/ui/main/community/community_question_tab.dart';
import 'package:look_talk/ui/main/community/community_recommend_tab.dart';
import 'package:provider/provider.dart';
import '../../../view_model/community/community_tab_view_model.dart';
import '../../common/const/colors.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  final List<Tab> tabs = const [
    Tab(text: '코디 질문'),
    Tab(text: '코디 추천'),
    Tab(text: 'My+'),
  ];

  final List<Widget> tabViews = const [
    CommunityQuestionTab(),
    CommunityRecommendTab(),
    CommunityMyTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CommunityTabViewModel>();

    return DefaultTabController(
      length: tabs.length,
      initialIndex: viewModel.currentTabIndex,
      child: Builder(
        builder: (BuildContext context) {
          final tabController = DefaultTabController.of(context)!;
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              context.read<CommunityTabViewModel>().setTabIndex(
                tabController.index,
              );
            }
          });

          return Scaffold(
            appBar: AppBarSearchCart(
              title: '커뮤니티',
              bottom: TabBar(
                tabs: tabs,
                labelStyle: context.bodyBold,
                labelColor: AppColors.black,
                unselectedLabelStyle: context.bodyBold,
                unselectedLabelColor: AppColors.textGrey,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.black, width: 3),
                  insets: EdgeInsets.symmetric(horizontal: 20),
                ),
                indicatorColor: AppColors.black,
                indicatorWeight: 3.0,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            body: TabBarView(children: tabViews),
            floatingActionButton: FloatingActionButton(
              // shape: const CircleBorder(
              //   side: BorderSide(width: 2, color: AppColors.black),
              // ),
              backgroundColor: AppColors.secondary,
              onPressed: () {
                //context.push('/community/write');
                //context.push('/login');
                //context.push('/signup');
                navigateWithAuthCheck(
                  context: context,
                  destinationIfLoggedIn: '/community/write',
                  fallbackIfNotLoggedIn: '/login',
                );
              },
              elevation: 0,
              child: const Icon(Icons.add, color: AppColors.white,),
            ),
          );
        },
      ),
    );
  }
}
