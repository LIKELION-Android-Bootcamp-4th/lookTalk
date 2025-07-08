import 'package:flutter/material.dart';

import '../../model/entity/post_entity.dart';
import '../../model/repository/post_repository.dart';

class CommunityViewModel with ChangeNotifier {
  final PostRepository _repository;
  CommunityViewModel(this._repository);

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadPosts(PostCategory category) async {
    _isLoading = true;
    notifyListeners();

    try {
     // _posts = await _repository.fetchPosts(category.name);
    } catch (e) {
      print('에러: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
