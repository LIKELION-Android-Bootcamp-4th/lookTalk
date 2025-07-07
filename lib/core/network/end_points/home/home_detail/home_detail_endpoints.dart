class HomeDetailEndpoints {
  static const String reviews = "/api/products/{productId}/reviews"; //GET 상품 리뷰
  static const String allSearch = "/api/search"; // GET 제품에 대한 모든 정보 (상품, 콘텐츠, 리뷰, 스토어)
  static const String allInquiries = "/api/admin/inquiries"; //GET 문의하기 전체 정보
  static const String detailInquiries = '/api/admin/inquiries/{id}'; //GET 특정 id로 문의하기 확인
  static const String storeLike = '/api/stores/{storeId}/like-toggle'; // POST 좋아요 클릭
  static const String orderProduct = '/api/orders'; // POST 주문하기
}


//커뮤니티 관련 api 없음.
// 제품에 대한 모든 정보 api는 한번 확인이 필요.