import 'package:flutter/material.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/ui/main/community/community_my_tab.dart';
import 'package:look_talk/view_model/community/community_tab_view_model.dart';
import 'package:look_talk/view_model/community/community_view_model.dart';
import 'package:provider/provider.dart';

import 'core/app.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommunityTabViewModel()),
        ChangeNotifierProvider(create: (_) => CommunityViewModel(PostRepository()))
      ],
      child: MyApp()));
}
