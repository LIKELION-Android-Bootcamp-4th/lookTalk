import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/main/community/community_my_tab.dart';
import 'package:look_talk/ui/main/community/community_question_tab.dart';
import 'package:look_talk/ui/main/community/community_recommend_tab.dart';
import 'package:look_talk/ui/main/community/post_create_screen.dart';

import '../../common/const/colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> tabs = [
    Tab(text: '코디 질문'),
    Tab(text: '코디 추천'),
    Tab(text: 'My+'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onFabPressed() {
    context.push('/community/write');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
          labelStyle: context.bodyBold,
          labelColor: AppColors.black,
          unselectedLabelStyle: context.bodyBold,
          unselectedLabelColor: AppColors.textGrey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.black, width: 3),
            insets: EdgeInsets.symmetric(horizontal: 20),
          ),
          indicatorColor: AppColors.black,
          indicatorWeight: 3.0,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CommunityQuestionTab(),
          CommunityRecommendTab(),
          CommunityMyTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(side: BorderSide(width: 2, color: AppColors.black)),
        backgroundColor: AppColors.white,
        onPressed: onFabPressed,
        child: Icon(Icons.add),
        elevation: 0,
      ),
    );
  }
}
