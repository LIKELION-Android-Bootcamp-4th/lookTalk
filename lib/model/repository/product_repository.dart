import 'package:dio/dio.dart';
import '../entity/product_entity.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<Product> fetchProductDetail(String productId) async {
    final path = '/api/products/$productId';

    try {
      final response = await _dio.get(path);

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return Product.fromJson(data);
      } else {
        throw Exception('상품 상세 정보 로드 실패');
      }
    } catch (e) {
      print('상품 상세 정보 불러오기 실패: $e');
      rethrow;
    }
  }
}
