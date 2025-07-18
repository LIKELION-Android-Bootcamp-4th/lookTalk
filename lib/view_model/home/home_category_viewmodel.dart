import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/category_detail_response.dart';
import 'package:look_talk/model/repository/category_detail_repository.dart';

class HomeCategoryViewModel with ChangeNotifier {
  final CategoryDetailRepository _categoryDetailRepository;

  HomeCategoryViewModel(this._categoryDetailRepository) {
    _initialize();
  }

  bool _isLoading = true;
  String _selectedCategoryName = '전체';
  List<CategoryDetailResponse> _productList = [];

  // 사용자에게 보여줄 카테고리 이름 리스트
  final List<String> _categoryNames = [
    '전체',
    '상의',
    '하의',
    '아우터',
    '원피스',
    '스커트',
  ];

  // 카테고리 이름 → categoryId 리스트 매핑
  final Map<String, List<String>> _categoryNameToIds = {
    '상의': [
      // 남성 상의
      '686ca5a05cb34c70a30b47a7', // 전체
      '686ca5ba5cb34c70a30b47e2', // 티셔츠
      '686ca60e5cb34c70a30b481a', // 셔츠
      '686ca6645cb34c70a30b4825', // 슬리브리스
      '686ca6815cb34c70a30b4830', // 니트/스웨터
      '686ca6c45cb34c70a30b4842', // 맨투맨
      '686ca6e25cb34c70a30b487d', // 후드

      // 여성 상의
      '686cbfda5cb34c70a30b4d33', // 티셔츠
      '686cbfe35cb34c70a30b4d3e', // 셔츠
      '686cc3a25cb34c70a30b4da1', // 슬리브리스
      '686cc3ab5cb34c70a30b4dad', // 니트/스웨터
      '686cc3db5cb34c70a30b4db8', // 맨투맨
      '686cc3e15cb34c70a30b4dc3', // 후드
      '686cc3885cb34c70a30b4d7a', // 블라우스
    ],
    '하의': [
      // 남성 하의
      '686ca7955cb34c70a30b48a8', // 데님
      '686ca8775cb34c70a30b48b3', // 슬랙스
      '686ca8995cb34c70a30b48be', // 트레이닝
      '686ca8bd5cb34c70a30b48cb', // 레깅스

      // 여성 하의
      '686cc3f25cb34c70a30b4dd8', // 데님
      '686cc3f75cb34c70a30b4de3', // 슬랙스
      '686cc4085cb34c70a30b4dee', // 트레이닝
      '686cc4125cb34c70a30b4e29', // 레깅스
    ],
    '아우터': [
      // 남성 아우터
      '686cb46b5cb34c70a30b4a3d', // 패딩
      '686cb47e5cb34c70a30b4a48', // 코트
      '686cb4ac5cb34c70a30b4a53', // 트렌치 코트
      '686cb52f5cb34c70a30b4a69', // 자켓
      '686cb5235cb34c70a30b4a5e', // 무스탕

      // 여성 아우터
      '686cc43e5cb34c70a30b4e76', // 패딩
      '686cc4455cb34c70a30b4e81', // 코트
      '686cc44a5cb34c70a30b4e8c', // 트렌치 코트
      '686cc4635cb34c70a30b4ead', // 자켓
      '686cc4555cb34c70a30b4ea2', // 무스탕
      '686cc44e5cb34c70a30b4e97', // 야상
    ],
    '스커트': [
      '686cc42f5cb34c70a30b4e55', // 롱 스커트
      '686cc4345cb34c70a30b4e60', // 미니 스커트
      '686cc4395cb34c70a30b4e6b', // 미디 스커트
    ],
    '원피스': [
      '686cc41a5cb34c70a30b4e34', // 롱 원피스
      '686cc4205cb34c70a30b4e3f', // 미니 원피스
      '686cc4295cb34c70a30b4e4a', // 미디 원피스
    ],
    '전체': [
      // 남성 상의
      '686ca5a05cb34c70a30b47a7',
      '686ca5ba5cb34c70a30b47e2',
      '686ca60e5cb34c70a30b481a',
      '686ca6645cb34c70a30b4825',
      '686ca6815cb34c70a30b4830',
      '686ca6c45cb34c70a30b4842',
      '686ca6e25cb34c70a30b487d',
      // 여성 상의
      '686cbfda5cb34c70a30b4d33',
      '686cbfe35cb34c70a30b4d3e',
      '686cc3a25cb34c70a30b4da1',
      '686cc3ab5cb34c70a30b4dad',
      '686cc3db5cb34c70a30b4db8',
      '686cc3e15cb34c70a30b4dc3',
      '686cc3885cb34c70a30b4d7a',
      // 남성 하의
      '686ca7955cb34c70a30b48a8',
      '686ca8775cb34c70a30b48b3',
      '686ca8995cb34c70a30b48be',
      '686ca8bd5cb34c70a30b48cb',
      // 여성 하의
      '686cc3f25cb34c70a30b4dd8',
      '686cc3f75cb34c70a30b4de3',
      '686cc4085cb34c70a30b4dee',
      '686cc4125cb34c70a30b4e29',
      // 남성 아우터
      '686cb46b5cb34c70a30b4a3d',
      '686cb47e5cb34c70a30b4a48',
      '686cb4ac5cb34c70a30b4a53',
      '686cb52f5cb34c70a30b4a69',
      '686cb5235cb34c70a30b4a5e',
      // 여성 아우터
      '686cc43e5cb34c70a30b4e76',
      '686cc4455cb34c70a30b4e81',
      '686cc44a5cb34c70a30b4e8c',
      '686cc4635cb34c70a30b4ead',
      '686cc4555cb34c70a30b4ea2',
      '686cc44e5cb34c70a30b4e97',
      // 스커트
      '686cc42f5cb34c70a30b4e55',
      '686cc4345cb34c70a30b4e60',
      '686cc4395cb34c70a30b4e6b',
      // 원피스
      '686cc41a5cb34c70a30b4e34',
      '686cc4205cb34c70a30b4e3f',
      '686cc4295cb34c70a30b4e4a',
    ],

  };

  bool get isLoading => _isLoading;
  List<String> get categoryNames => _categoryNames;
  String get selectedCategoryName => _selectedCategoryName;
  List<CategoryDetailResponse> get productList => _productList;

  Future<void> _initialize() async {
    await fetchProductsByCategory(_selectedCategoryName);
  }

  Future<void> fetchProductsByCategory(String categoryName) async {
    _isLoading = true;
    notifyListeners();

    try {
      final categoryIds = _categoryNameToIds[categoryName] ?? [];
      final List<CategoryDetailResponse> allProducts = [];

      if (categoryIds.isEmpty && categoryName == '전체') {
        final products = await _categoryDetailRepository.fetchAllProducts();
        allProducts.addAll(products);
      } else {
        for (final id in categoryIds) {
          final products = await _categoryDetailRepository.categoryResultDetail(id);
          allProducts.addAll(products);
        }
      }

      _productList = allProducts;
    } catch (e) {
      print('카테고리 상품 불러오기 오류: $e');
      _productList = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void changeHomeCategory(String categoryName) {
    if (_selectedCategoryName == categoryName) return;
    _selectedCategoryName = categoryName;
    fetchProductsByCategory(categoryName);
    notifyListeners();
  }
}
