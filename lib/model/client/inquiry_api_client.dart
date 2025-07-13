import 'package:dio/dio.dart';
import '../entity/inquiry_entity.dart';
import 'package:look_talk/core/network/token_storage.dart';

class InquiryApiClient {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  InquiryApiClient(this._dio, this._tokenStorage);

  Future<List<Inquiry>> fetchMyInquiries(String productId) async {
    final token = await _tokenStorage.getAccessToken();
    final response = await _dio.get(
      '/api/inquiries',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      queryParameters: {'productId': productId},
    );

    final data = response.data['data'] as List;
    return data.map((e) => Inquiry.fromJson(e)).toList();
  }
}