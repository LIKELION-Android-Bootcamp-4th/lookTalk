import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/category/category_endpoints.dart';
import 'package:look_talk/model/entity/response/category_detail_response.dart';

class CategoryDetailRepository {
  Dio _dio;
  CategoryDetailRepository(this._dio);

  Future<List<CategoryDetailResponse>> categoryResultDetail(String categoryId) async {
    try {
      print("🔍 categoryResultDetail 요청: categoryId = $categoryId");

      final response = await _dio.get(
        CategoryEndpoints.categoryProduct,
        queryParameters: {
          'categoryId': categoryId,
        },
      );

      print("📦 서버 응답 (categoryId=$categoryId): ${response.data}");

      final items = response.data['data']?['items'] as List? ?? [];

      print("✅ categoryId=$categoryId → 불러온 상품 수: ${items.length}");

      return items.map((e) => CategoryDetailResponse.fromJson(e)).toList();
    } catch (e) {
      print("❌ 제품 값을 가져오지 못했습니다 (categoryId=$categoryId) : $e");
      return [];
    }
  }

  Future<List<CategoryDetailResponse>> fetchAllProducts() async {
    try {
      print("🔍 전체 상품 요청 시작");

      final response = await _dio.get('/api/categories/products');

      print("📦 전체 상품 응답: ${response.data}");

      final items = response.data['data']?['items'] as List? ?? [];

      print("✅ 전체 상품 개수: ${items.length}");

      return items.map((e) => CategoryDetailResponse.fromJson(e)).toList();
    } catch (e) {
      print('❌ 전체 상품 불러오기 실패: $e');
      return [];
    }
  }
}
