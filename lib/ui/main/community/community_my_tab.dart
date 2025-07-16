import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/common_dropdown.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:look_talk/view_model/community/community_tab_view_model.dart';
import 'package:provider/provider.dart';

import '../../../model/entity/request/post_list_request.dart';
import '../../../view_model/community/my_post_list_view_model.dart';
import '../../common/component/community/post_list.dart';
import '../../common/const/gap.dart';

// class CommunityMyTab extends StatelessWidget {
//   const CommunityMyTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<MyPostListViewModel>();
//
//     return Column(
//       children: [
//         _buildSortDropdown(vm),
//         Expanded(child: _buildPostList(vm, context)),
//       ],
//     );
//   }
//
//   Widget _buildSortDropdown(MyPostListViewModel vm,) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 24, right: 16),
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: CommonDropdown(
//           items: SortType.values.map((e) => e.label).toList(),
//           selectedValue: vm.sortType.label,
//           hintText: '정렬 기준',
//           onChanged: (label) {
//             final newSort = SortTypeFromString.fromLabel(label ?? '');
//             vm.changeSort(newSort);
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPostList(MyPostListViewModel vm, BuildContext context) {
//     if (vm.isLoading && vm.posts.isEmpty) {
//       return const Center(child: CommonLoading());
//     }
//
//     if (!vm.isLoading && vm.posts.isEmpty) {
//       return const Center(child: Text('게시글이 없습니다.'));
//     }
//
//     return PostList(posts: vm.posts, onRefresh: () async {
//       await vm.fetchPosts(reset: true);
//     }, rootContext: context,);
//   }
// }
class CommunityMyTab extends StatefulWidget {
  const CommunityMyTab({super.key});

  @override
  State<CommunityMyTab> createState() => _CommunityMyTabState();
}

// class _CommunityMyTabState extends State<CommunityMyTab> {
//   bool _fetched = false;
//   bool _listenerRegistered = false;
//   CommunityTabViewModel? _tabViewModel;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     _tabViewModel ??= context.read<CommunityTabViewModel>();
//
//     if (!_listenerRegistered) {
//       _tabViewModel!.addListener(_onTabChanged);
//       _listenerRegistered = true;
//     }
//
//     if (!_fetched) {
//       Future.microtask(() {
//         context.read<MyPostListViewModel>().fetchPosts(reset: true);
//       });
//       _fetched = true;
//     }
//   }
//
//   void _onTabChanged() {
//     final currentIndex = _tabViewModel?.currentTabIndex;
//
//     // 이 탭이 현재 탭이면 새로고침
//     if (currentIndex == 2) {
//       print('마이 탭 전환됨 → 게시글 새로고침');
//       context.read<MyPostListViewModel>().fetchPosts(reset: true);
//     }
//   }
//
//   @override
//   void dispose() {
//     _tabViewModel?.removeListener(_onTabChanged);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<MyPostListViewModel>();
//
//     return Column(
//       children: [
//         _buildSortDropdown(vm),
//         Expanded(child: _buildPostList(vm, context)),
//       ],
//     );
//   }
//
//   Widget _buildSortDropdown(MyPostListViewModel vm) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 24, right: 16),
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: CommonDropdown(
//           items: SortType.values.map((e) => e.label).toList(),
//           selectedValue: vm.sortType.label,
//           hintText: '정렬 기준',
//           onChanged: (label) {
//             final newSort = SortTypeFromString.fromLabel(label ?? '');
//             vm.changeSort(newSort); // 내부에서 fetchPosts 실행
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPostList(MyPostListViewModel vm, BuildContext context) {
//     if (vm.isLoading && vm.posts.isEmpty) {
//       return const Center(child: CommonLoading());
//     }
//
//     if (!vm.isLoading && vm.posts.isEmpty) {
//       return const Center(child: Text('게시글이 없습니다.'));
//     }
//
//     return PostList(
//       posts: vm.posts,
//       onRefresh: () async {
//         await vm.fetchPosts(reset: true);
//       },
//       rootContext: context,
//     );
//   }
// }

class _CommunityMyTabState extends State<CommunityMyTab> {
  late final CommunityTabViewModel _tabViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabViewModel = context.read<CommunityTabViewModel>();
      _tabViewModel.addListener(_onTabChanged);

      context.read<MyPostListViewModel>().fetchPosts(reset: true);
    });
  }

  void _onTabChanged() {
    if (_tabViewModel.currentTabIndex == 2) {
      print('[MyTab] 게시글 새로고침');
      context.read<MyPostListViewModel>().fetchPosts(reset: true);
    }
  }

  @override
  void dispose() {
    _tabViewModel.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyPostListViewModel>();

    return Column(
      children: [
        _buildSortDropdown(vm),
        Expanded(child: _buildPostList(vm, context)),
      ],
    );
  }

  Widget _buildSortDropdown(MyPostListViewModel vm) {
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

  Widget _buildPostList(MyPostListViewModel vm, BuildContext context) {
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
