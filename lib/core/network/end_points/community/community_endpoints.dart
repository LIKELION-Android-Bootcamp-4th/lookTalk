class CommunityEndpoints {
  static const String allPosts = '/api/posts'; //GET 카테고리를 통해 조회

  //static const String postManage = '/api/posts/{postId}';
  static const String postManageBase = '/api/posts';
  static String postManage(String postId) => '$postManageBase/$postId';
  static String postLike(String postId) => '$postManageBase/$postId/like-toggle';
  static String writeComments(String postId) => '$postManageBase/$postId/comments';

  //글 작성 endpoints
  static const String writePost = '/api/posts'; // POST 포스트 글 작성.

  //상품 정보 추가 endpoints
  static const String myProductOrder = '/api/mypage/orders'; //GET 주문 상품 목록 조회
  static const String myProductOrderDetail = '/api/mypage/orders/{orderId}'; //GET 주문 상품 세부 정보


}

// TODO: my+ 수정 및 삭제는 시간 남으면!!

