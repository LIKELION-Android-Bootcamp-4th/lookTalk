import 'package:flutter/material.dart';
import 'package:look_talk/model/repository/notice_repository.dart';
import 'package:look_talk/model/entity/notice_entity.dart';

class NoticeViewModel extends ChangeNotifier {
  final NoticeRepository _repository = NoticeRepository();

  List<NoticeEntity> _notices = [];
  List<NoticeEntity> get notices => _notices;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadNotices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final dtos = await _repository.fetchNoticeList();
      _notices = dtos.map((e) => e.toEntity()).toList();
    } catch (e) {
      print('오류: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}