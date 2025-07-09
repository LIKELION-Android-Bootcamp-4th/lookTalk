import 'package:flutter/material.dart';
import '../../model/entity/post_entity.dart';
import '../../model/repository/post_repository.dart';

class PostDetailViewModel with ChangeNotifier {
  final PostRepository _repository;

  Post? _post;
  Post? get post => _post;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get errorMessage => _error;

  PostDetailViewModel(this._repository, String postId){
    fetchPost(postId);
  }


  Future<void> fetchPost(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.fetchPosts(id);
      if (result.success && result.data != null) {
        _post = Post.fromResponse(result.data!);
        _error = null;
      } else {
        _error = result.message ?? '알 수 없는 오류';
        _post = null;
      }
    } catch (e) {
      _error = '에러 발생: ${e.toString()}';
      _post = null;
    }
    _isLoading = false;
    notifyListeners();
  }
}
