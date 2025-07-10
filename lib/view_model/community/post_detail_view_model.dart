import 'package:flutter/material.dart';
import '../../model/entity/post_entity.dart';
import '../../model/repository/post_repository.dart';

class PostDetailViewModel with ChangeNotifier {
  final PostRepository _repository;

  Post? _post;
  bool _isLoading = false;
  String? _error;

  Post? get post => _post;
  bool get isLoading => _isLoading;
  String? get errorMessage => _error;

  // 좋아요
  bool _isLiked = false;
  bool get isLiked => _isLiked;

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

  Future<void> toggleLike() async {
    if(_post == null ) return;

    final postId = _post!.id;

    _isLiked = !_isLiked;
    _post = _post!.copyWith(
      likeCount: _isLiked ? _post!.likeCount + 1 : _post!.likeCount - 1
    );
    notifyListeners();

    try {
      await _repository.toggleLike(postId); // 서버에 좋아요 요청
    } catch (e) {
      // 실패 시 롤백
      _isLiked = !_isLiked;
      _post = _post!.copyWith(
        likeCount: _isLiked ? _post!.likeCount + 1 : _post!.likeCount - 1,
      );
      notifyListeners();
    }
  }
}
