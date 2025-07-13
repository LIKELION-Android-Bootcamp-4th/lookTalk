import 'package:dio/dio.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/core/network/token_storage.dart';

class SellerProductApiClient {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  SellerProductApiClient(this._dio, this._tokenStorage);

  Future<List<Product>> fetchProductList() async {
    final token = await _tokenStorage.getAccessToken();
    final companyCode = await _tokenStorage.getCompanyCode();

    final headers = {
      'Authorization': 'Bearer $token',
      'X-Company-Code': companyCode ?? '',
      'Content-Type': 'application/json',
    };

    try {
      final response = await _dio.get(
        '/api/seller/products',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final items = response.data['data']['items'] as List<dynamic>;
        return items.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('상품 목록 조회 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('상품 목록 조회 Dio 오류: ${e.response?.data}');
      rethrow;
    }
  }
}
