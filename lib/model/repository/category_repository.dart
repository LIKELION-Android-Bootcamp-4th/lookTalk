import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/home/home_endpoints.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';


class CategoryRepository {
  final Dio _dio;

  CategoryRepository(this._dio);

  Future<List<BringSubCategoryResponse>> categoryResult(String parentId) async{
    try {
      final response = await _dio.get(
        '${HomeEndpoints.homeProductCategoryList}$parentId',
      );
      final data = response.data['data']['children'] as List;

      return data.map((e) => BringSubCategoryResponse.fromJson(e)).toList();

    }catch(e) {
      print("에러 발생 : ${e}");
      return [];

    }
  }
}