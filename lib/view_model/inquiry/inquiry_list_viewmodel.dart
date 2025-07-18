import 'package:flutter/material.dart';
import '../../model/repository/inquiry_repository.dart';
import '../../model/entity/inquiry_entity.dart';

class InquiryListViewModel extends ChangeNotifier {
  final InquiryRepository repository;
  final String productId;

  InquiryListViewModel({required this.repository, required this.productId}) {
    loadInquiries();
  }

  List<Inquiry> inquiries = [];
  bool isLoading = false;

  Future<void> loadInquiries() async {
    isLoading = true;
    notifyListeners();

    try {
      inquiries = await repository.getInquiries(productId);
    } catch (e) {
      print('문의 조회 실패: $e');
      inquiries = [];
    }

    isLoading = false;
    notifyListeners();
  }
}