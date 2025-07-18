import 'package:flutter/material.dart';
import '../../core/network/token_storage.dart';
import '../../model/entity/comment.dart';
import '../../model/entity/post_entity.dart';
import '../../model/entity/request/comment_request.dart';
import '../../model/entity/response/comment_response.dart';
import '../../model/repository/post_repository.dart';

class PostDetailViewModel with ChangeNotifier {
  final PostRepository _repository;
  final TokenStorage _tokenStorage;

  Post? _post;
  bool _isLoading = false;
  String? _error;
  String? _currentUserId;
  bool _isLiked = false;
  bool _hasNewComment = false;
  bool _hasLikedChanged = false;

  Post? get post => _post;
  bool get isLoading => _isLoading;
  String? get errorMessage => _error;
  bool get isLiked => _isLiked;
  bool get hasNewComment => _hasNewComment;
  bool get hasLikedChanged => _hasLikedChanged;

  final TextEditingController commentController = TextEditingController();
  final List<CommentResponse> comments = [];

  void markNewComment() {
    _hasNewComment = false;
  }

  void markLikedChanged() {
    _hasLikedChanged = true;
  }

  void resetFlags() {
    _hasNewComment = false;
    _hasLikedChanged = false;
  }

  PostDetailViewModel(this._repository, this._tokenStorage, String postId) {
    _init(postId);
  }

  Future<void> _init(String postId) async {
    await _fetchCurrentUserId();
    await fetchPost(postId);
  }

  Future<void> _fetchCurrentUserId() async {
    _currentUserId = await _tokenStorage.getUserId();
    print('현재 로그인된 유저 ID: $_currentUserId');
  }

  bool get isAuthor => _post?.user.id == _currentUserId;

  Future<void> fetchPost(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.fetchPosts(id);
      if (result.success && result.data != null) {
        _post = Post.fromResponse(result.data!);
        _isLiked = post?.isLiked ?? false;
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
    if (_post == null) return;

    final postId = _post!.id;

    final previousLikedState = _isLiked;
    final previousLikeCount = _post!.likeCount;

    _isLiked = !_isLiked;
    _post = _post!.copyWith(
      likeCount: _isLiked ? previousLikeCount + 1 : previousLikeCount - 1,
    );
    notifyListeners();

    try {
      await _repository.toggleLike(postId); // 서버에 좋아요 요청
      if(_isLiked != previousLikedState){
        _hasLikedChanged = true;
      }
    } catch (e) {
      _isLiked = previousLikedState;
      _post = _post!.copyWith(likeCount: previousLikeCount);
      notifyListeners();
    }
  }

  Future<bool> submitComment(String postId) async {
    final content = commentController.text.trim();
    if (content.isEmpty) return false;

    final request = CommentRequest(content: content);
    final result = await _repository.addComment(
      postId: postId,
      request: request,
    );

    if (result.success && result.data != null) {
      _hasNewComment = true;
      final newComment = Comment.fromResponse(result.data!);

      final updatedComments = List<Comment>.from(post!.comments)
        ..add(newComment);

      _post = _post!.copyWith(comments: updatedComments, commentCount: _post!.commentCount + 1);
      commentController.clear();
      notifyListeners();
      return true;
    } else {
      print('댓글 작성 실패: ${result.message}');
      return false;
    }
  }

  Future<bool> deletePost() async {
    if (_post == null) {
      _error = '게시글 정보가 없습니다.';
      return false;
    }

    final result = await _repository.deletePost(_post!.id);
    return result.success;
  }
}
