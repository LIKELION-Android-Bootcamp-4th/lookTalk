import 'base_post_list_view_model.dart';
import '../../../model/entity/request/post_list_request.dart';
import '../../../model/repository/post_repository.dart';

class QuestionPostListViewModel extends BasePostListViewModel {
  QuestionPostListViewModel(PostRepository repository)
      : super(
    repository,
    PostListRequest(
      page: 0,
      limit: 20,
      category: 'coord_question',
      sortBy: 'createdAt',
      sortOrder: 'desc',
    ),
  );
}
