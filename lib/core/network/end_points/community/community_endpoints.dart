class CommunityEndpoints {
  static const String allPosts = '/api/posts'; //GET 카테고리를 통해 조회

  static const String postManage = '/api/posts/{postId}'; //GET, PATCH, DELETE 상세 조회,수정,삭제

  //글 작성 endpoints
  static const String writePost = '/api/posts'; // POST 포스트 글 작성.

  //글 상세 페이지 endpoints
  static const String writeComments = '/api/posts/{postId}/comments'; //POST 댓글 작성

  //상품 정보 추가 endpoints
  static const String myProductOrder = '/api/mypage/orders'; //GET 주문 상품 목록 조회
  static const String myProductOrderDetail = '/api/mypage/orders/{orderId}'; //GET 주문 상품 세부 정보
}

// my+디자인이 초반에 내가 작성한 글 리스트 보여주기 및 수정 삭제로 기억하고 있어 이부분 디자인 수정이 필요할 것 같습니다.
//댓글 작성은 있는데 커뮤니티에 대한 댓글 목록 조회가 보이지 않습니다.