import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/common_dropdown.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:provider/provider.dart';

import '../../../model/entity/request/post_list_request.dart';
import '../../../view_model/community/recommend_post_list_view_model.dart';
import '../../common/component/community/post_list.dart';

class CommunityRecommendTab extends StatelessWidget {
  const CommunityRecommendTab({super.key});

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

    return PostList(posts: vm.posts, onRefreshAfterDelete: () async {
      await vm.fetchPosts(reset: true);
    }, rootContext: context,);
  }
}
