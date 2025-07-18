import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/entity/request/post_list_request.dart';
import '../../../view_model/community/community_tab_view_model.dart';
import '../../../view_model/community/recommend_post_list_view_model.dart';
import '../../common/component/common_dropdown.dart';
import '../../common/component/common_loading.dart';
import '../../common/component/community/post_list.dart';

class CommunityRecommendTab extends StatefulWidget {
  const CommunityRecommendTab({super.key});

  @override
  State<CommunityRecommendTab> createState() => _CommunityRecommendTabState();
}

class _CommunityRecommendTabState extends State<CommunityRecommendTab> {
  late final CommunityTabViewModel _tabViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabViewModel = context.read<CommunityTabViewModel>();
      _tabViewModel.addListener(_onTabChanged);

      context.read<RecommendPostListViewModel>().fetchPosts(reset: true);
    });
  }

  void _onTabChanged() {
    if (_tabViewModel.currentTabIndex == 1) {
      print('[RecommendTab] 게시글 새로고침');
      context.read<RecommendPostListViewModel>().fetchPosts(reset: true);
    }
  }

  @override
  void dispose() {
    _tabViewModel.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecommendPostListViewModel>();

    return Column(
      children: [
        _buildSortDropdown(vm),
        Expanded(child: _buildPostList(vm, context)),
      ],
    );
  }

  Widget _buildSortDropdown(RecommendPostListViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, right: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: CommonDropdown(
          items: SortType.values.map((e) => e.label).toList(),
          selectedValue: vm.sortType.label,
          hintText: '정렬 기준',
          onChanged: (label) {
            final newSort = SortTypeFromString.fromLabel(label ?? '');
            vm.changeSort(newSort);
          },
        ),
      ),
    );
  }

  Widget _buildPostList(RecommendPostListViewModel vm, BuildContext context) {
    if (vm.isLoading && vm.posts.isEmpty) {
      return const Center(child: CommonLoading());
    }

    if (!vm.isLoading && vm.posts.isEmpty) {
      return const Center(child: Text('게시글이 없습니다.'));
    }

    return PostList(
      posts: vm.posts,
      onRefresh: () async {
        await vm.fetchPosts(reset: true);
      },
      rootContext: context,
    );
  }
}
