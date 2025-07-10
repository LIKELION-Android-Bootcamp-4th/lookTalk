import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:look_talk/core/network/token_storage.dart';

import '../../../view_model/viewmodel_provider.dart';
import 'community_screen.dart';

// class CommunityEntryPoint extends StatelessWidget {
//   const CommunityEntryPoint({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print('[CommunityEntryPoint] build 시작');
//     return FutureBuilder<String?>(
//       future: TokenStorage().getUserId(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const CommonLoading();
//
//         final userId = snapshot.data;
//         if (userId == null || userId.isEmpty) {
//           // 로그인 안 되어 있으면 로그인 화면으로 이동
//           print('로그인 안되어있음');
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             context.go('/login');
//           });
//           return const SizedBox.shrink();
//         }
//         print('로그인 되어있음');
//
//         return MultiProvider(
//           providers: [
//             ChangeNotifierProvider(
//               create: (_) => provideQuestionPostListViewModel()..fetchPosts(reset: true),
//             ),
//             ChangeNotifierProvider(
//               create: (_) => provideRecommendPostListViewModel()..fetchPosts(reset: true),
//             ),
//             ChangeNotifierProvider(
//               create: (_) => provideMyPostListViewModel(userId)..init(),
//             ),
//             ChangeNotifierProvider(
//               create: (_) => provideCommunityTabViewModel(),
//             ),
//           ],
//           child: const CommunityScreen(),
//         );
//       },
//     );
//   }
// }

class CommunityEntryPoint extends StatefulWidget {
  const CommunityEntryPoint({super.key});

  @override
  State<CommunityEntryPoint> createState() => _CommunityEntryPointState();
}

class _CommunityEntryPointState extends State<CommunityEntryPoint> {
  String? _userId;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    print('[CommunityEntryPoint] 로그인 상태 확인 시작');
    final userId = await TokenStorage().getUserId();
    print('[CommunityEntryPoint] 로그인 결과: $userId');

    if (!mounted) return;

    if (userId == null || userId.isEmpty) {
      print('[CommunityEntryPoint] 로그인 안 되어 있음 → /login 이동');
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
    print('[CommunityEntryPoint] build() 실행됨');

    if (_checking) return const CommonLoading();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => provideQuestionPostListViewModel()..fetchPosts(reset: true)),
        ChangeNotifierProvider(create: (_) => provideRecommendPostListViewModel()..fetchPosts(reset: true)),
        ChangeNotifierProvider(create: (_) => provideMyPostListViewModel(_userId!)..init()),
        ChangeNotifierProvider(create: (_) => provideCommunityTabViewModel()),
      ],
      child: const CommunityScreen(),
    );
  }
}
