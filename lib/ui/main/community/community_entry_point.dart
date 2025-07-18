import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:look_talk/core/network/token_storage.dart';

import '../../../view_model/community/question_post_list_view_model.dart';
import '../../../view_model/community/recommend_post_list_view_model.dart';
import '../../../view_model/viewmodel_provider.dart';
import 'community_screen.dart';

class CommunityEntryPoint extends StatefulWidget {
  const CommunityEntryPoint({super.key});

  @override
  State<CommunityEntryPoint> createState() => _CommunityEntryPointState();
}


class _CommunityEntryPointState extends State<CommunityEntryPoint> {
  String? _userId;
  bool _checking = true;
  bool _hasFetched = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final userId = await TokenStorage().getUserId();
    if (!mounted) return;

    if (userId == null || userId.isEmpty) {
      context.go('/login');
    } else {
      setState(() {
        _userId = userId;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) return const CommonLoading();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => provideQuestionPostListViewModel()),
        ChangeNotifierProvider(create: (_) => provideRecommendPostListViewModel()),
        ChangeNotifierProvider(create: (_) => provideMyPostListViewModel(_userId!)..init()),
        ChangeNotifierProvider(create: (_) => provideCommunityTabViewModel()),
      ],
      child: Builder(
        builder: (context) {
          // 탭 초기 진입 시 한 번만 호출
          if (!_hasFetched) {
            Future.microtask(() {
              context.read<QuestionPostListViewModel>().fetchPosts(reset: true);
              context.read<RecommendPostListViewModel>().fetchPosts(reset: true);
            });
            _hasFetched = true;
          }
          return const CommunityScreen();
        },
      ),
    );
  }
}

