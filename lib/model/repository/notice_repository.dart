import 'package:dio/dio.dart';
import 'package:look_talk/core/network/dio_client.dart';
import 'package:look_talk/model/dto/notice_dto.dart';

class NoticeRepository {
  Future<List<NoticeDto>> fetchNoticeList() async {
    try {
      final Response response = await DioClient.instance.get('/api/notice');

      final data = response.data;

      final List<dynamic> items = data['data']['items'];

      return items.map((item) => NoticeDto.fromJson(item)).toList();
    } catch (e) {
      print('공지사항 불러오기 실패: $e');
      rethrow;
    }
  }
}