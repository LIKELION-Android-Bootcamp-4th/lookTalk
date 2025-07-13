import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:look_talk/model/inquiry.dart';  // Inquiry 모델 추가

class InquiryViewModel extends ChangeNotifier {
  final Dio _dio = Dio(); // Dio 인스턴스 생성
  List<Inquiry> inquiries = [];
  bool isLoading = false;

  Future<void> fetchInquiries() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await _dio.get('/api/inquiries');
      inquiries = (response.data as List)
          .map((inquiryData) => Inquiry.fromJson(inquiryData))
          .toList();
    } catch (e) {
      // Error 처리
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createInquiry(String content) async {
    try {
      final response = await _dio.post('/api/inquiries', data: {
        'content': content,
      });
      inquiries.add(Inquiry.fromJson(response.data));
      notifyListeners();
    } catch (e) {
      // Error 처리
    }
  }
}