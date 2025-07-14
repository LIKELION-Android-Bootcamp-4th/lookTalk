import 'base_post_list_view_model.dart';
import '../../../model/entity/request/post_list_request.dart';
import '../../../model/repository/post_repository.dart';

class RecommendPostListViewModel extends BasePostListViewModel {
  RecommendPostListViewModel(PostRepository repository)
      : super(
    repository,
    PostListRequest(
      page: 0,
      limit: 20,
      category: 'coord_recommend',
      sortBy: SortType.createdAt,
      sortOrder: SortOrder.desc,
    ),
  );
}
