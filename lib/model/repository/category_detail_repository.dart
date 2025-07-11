import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/category/category_endpoints.dart';
import 'package:look_talk/core/network/end_points/home/home_endpoints.dart';
import 'package:look_talk/model/entity/response/category_detail_response.dart';

class CategoryDetailRepository {
  Dio _dio;
  CategoryDetailRepository(this._dio);

  Future<List<CategoryDetailResponse>> categoryResultDetail(String categoryId) async {
    try {
      final response = await _dio.get(
        CategoryEndpoints.categoryProduct,
        queryParameters: {
          'categoryId' : categoryId
        }
      );
      final items = response.data['data']?['items'] as List? ?? [];
      return items.map((e) => CategoryDetailResponse.fromJson(e)).toList();
    }catch (e){
      print("제품 값을 가져오지 못합니다 : $e");
      return [];
    }

  }
}