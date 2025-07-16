import 'dart:io';

import 'package:dio/dio.dart';
import 'package:look_talk/model/entity/product_entity.dart';


class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<List<ProductEntity>> getProducts() async {
    final path = '/api/seller/products';

    try {
      final response = await _dio.get(path);
      final items = response.data['data']['items'] as List;
      return items.map((item) => ProductEntity.fromJson(item)).toList();
    } catch (e) {
      print('상품 목록 불러오기 실패: $e');
      rethrow;
    }
  }

  Future<ProductEntity> fetchProductDetail(String productId) async {
    final path = '/api/products/$productId';

    try {
      final response = await _dio.get(path);
      final data = response.data['data'] as Map<String, dynamic>;
      return ProductEntity.fromJson(data);
    } catch (e) {
      print('상품 상세 정보 불러오기 실패: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final path = '/api/seller/products/$productId';

    try {
      await _dio.delete(path);
      print('상품 삭제 성공');
    } catch (e) {
      print('상품 삭제 실패: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(
      String productId, {
        required int stock,
        required String status,
        required int price,
        int? discountRate,
        File? thumbnailImage,
      }) async {
    final path = '/api/seller/products/$productId';

    final formData = FormData.fromMap({
      'stock': stock,
      'status': status,
      'price': price,
      if (discountRate != null)
        'discount': {'type': 'percentage', 'value': discountRate},
    });

    try {
      await _dio.patch(path, data: formData);
      print('상품 수정 성공');
    } catch (e) {
      print('상품 수정 실패: $e');
      rethrow;
    }
  }
}
