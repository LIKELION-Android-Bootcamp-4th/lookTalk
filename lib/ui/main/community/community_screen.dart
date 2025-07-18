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
import '../../../view_model/community/my_post_list_view_model.dart';
import '../../../view_model/community/question_post_list_view_model.dart';
import '../../../view_model/community/recommend_post_list_view_model.dart';
import '../../common/const/colors.dart';

const List<Tab> _communityTabs = const [
  Tab(text: '코디 질문'),
  Tab(text: '코디 추천'),
  Tab(text: 'My+'),
];

const List<Widget> _tabViews = [
  CommunityQuestionTab(),
  CommunityRecommendTab(),
  CommunityMyTab(),
];

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CommunityTabViewModel>();

    return DefaultTabController(
      length: _communityTabs.length,
      initialIndex: viewModel.currentTabIndex,
      child: Builder(
        builder: (BuildContext context) {
          final tabController = DefaultTabController.of(context);
          final viewModel = context.read<CommunityTabViewModel>();
          tabController.addListener(() {
            // if (!tabController.indexIsChanging) {
            //   context.read<CommunityTabViewModel>().setTabIndex(
            //     tabController.index,
            //   );
            // }
            if (!tabController.indexIsChanging) {
              final currentIndex = tabController.index;
              final viewModel = context.read<CommunityTabViewModel>();

              final wasSameTab = viewModel.currentTabIndex == currentIndex;
              viewModel.setTabIndex(currentIndex);

              // 탭이 바뀌거나 같은 탭 다시 클릭한 경우
              switch (currentIndex) {
                case 0:
                  context.read<QuestionPostListViewModel>().fetchPosts(reset: true);
                  break;
                case 1:
                  context.read<RecommendPostListViewModel>().fetchPosts(reset: true);
                  break;
                case 2:
                  context.read<MyPostListViewModel>().fetchPosts(reset: true);
                  break;
              }
            }
          });

          return Scaffold(
            appBar: _buildAppBar(context),
            body: const TabBarView(children: _tabViews),
            floatingActionButton: _buildFAB(context),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBarSearchCart(
      title: '커뮤니티',
      bottom: TabBar(
        tabs: _communityTabs,
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
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -15),
      child: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          // shape: const CircleBorder(
          //   side: BorderSide(width: 2, color: AppColors.black),
          // ),
          backgroundColor: AppColors.primary,
          onPressed: () async {
            final postId = await navigateForPostWrite(context: context);
            //context.push('/community/write');
            //context.push('/login');
            //context.push('/signup');

            print('FAB 클릭 후 result 값: $postId');

            if (postId  != null && postId.isNotEmpty) {
              context.push('/post/$postId');
              Future.microtask(() {
                final tabIndex = context.read<CommunityTabViewModel>().currentTabIndex;

                switch (tabIndex) {
                  case 0:
                    context.read<QuestionPostListViewModel>().fetchPosts(reset: true);
                    break;
                  case 1:
                    context.read<RecommendPostListViewModel>().fetchPosts(reset: true);
                    break;
                  case 2:
                    context.read<MyPostListViewModel>().fetchPosts(reset: true);
                    break;
                }
              });

            }
          },
          elevation: 3,
          //shape: const CircleBorder(),
          child: const Icon(Icons.add, color: AppColors.white, size: 28),
        ),
      ),
    );
  }
}
