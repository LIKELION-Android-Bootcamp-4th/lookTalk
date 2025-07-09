import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:look_talk/core/network/token_storage.dart';

import '../../../view_model/viewmodel_provider.dart';
import 'community_screen.dart';

class CommunityEntryPoint extends StatelessWidget {
  const CommunityEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: TokenStorage().getUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CommonLoading();
        }

        final userId = snapshot.data!;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => provideQuestionPostListViewModel()..fetchPosts(reset: true),
            ),
            ChangeNotifierProvider(
              create: (_) => provideRecommendPostListViewModel()..fetchPosts(reset: true),
            ),
            ChangeNotifierProvider(
              create: (_) => provideMyPostListViewModel(userId)..init(),
            ),
            ChangeNotifierProvider(
              create: (_) => provideCommunityTabViewModel(),
            ),
          ],
          child: const CommunityScreen(),
        );
      },
    );
  }
}
