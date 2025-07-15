

import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';

class AdminNoticeRepository {
  final Dio _dio = DioClient.instance;

  Future<void> createNotice({required String title, required String content}) async {
    try {
      await _dio.post('/api/admin/notices', data: {
        'title': title,
        'content': content,
      });
    } catch (e) {
      print('공지사항 등록 실패: $e');
      rethrow;
    }
  }
}