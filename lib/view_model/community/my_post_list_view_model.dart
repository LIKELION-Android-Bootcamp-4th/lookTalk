import '../../core/network/token_storage.dart';
import 'base_post_list_view_model.dart';
import '../../../model/entity/request/post_list_request.dart';
import '../../../model/repository/post_repository.dart';

class MyPostListViewModel extends BasePostListViewModel {
  MyPostListViewModel(PostRepository repository, String userId)
      : super(
    repository,
    PostListRequest(
      page: 0,
      limit: 20,
      userId: userId,
      sortBy: SortType.createdAt,
      sortOrder: SortOrder.desc,
    ),
  );

  Future<void> init() async {
    final userId = await TokenStorage().getUserId();
    if (userId != null) {
      request = request.copyWith(userId: userId);
      await fetchPosts(reset: true);
    }
  }
}
