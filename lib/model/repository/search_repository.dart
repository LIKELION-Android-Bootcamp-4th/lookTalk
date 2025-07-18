import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/search.dart';
import 'package:look_talk/model/entity/response/search_response.dart';

class SearchRepository {
  final Dio _dio;

  SearchRepository(this._dio);

  Future<SearchResponse> searchResult(String query) async {
    try {
      final response = await _dio.get(
        Search.allSearch,
        queryParameters: {
          'q' : query,
          'postLimit' : 100
        },
      );

      return SearchResponse.fromJson(response.data);
    }catch (e, stack) {
      print("레포 스택 ${stack}");
      throw Exception('검색이 되지 않습니다. $e');
    }
  }
}