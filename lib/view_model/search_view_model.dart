import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/search_response.dart';
import 'package:look_talk/model/repository/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository repository;

  List<ProductSearch> products = [];
  List<CommunitySearch> communities = [];

  SearchViewModel({required this.repository});

  Future<void> search(String query) async {
    if (query.isEmpty) return;


    try {
      final result = await repository.searchResult(query);

      products = result.products;
      communities = result.community;
      notifyListeners();
    } catch (e) {
      print('검색에 오류 발생: $e');
    }
  }
}