import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/search_response.dart';
import 'package:look_talk/model/repository/search_repository.dart';

import '../model/entity/response/post_response.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository repository;

  List<ProductSearch> products = [];
  List<PostResponse> communities = [];
  List<PostResponse> recommendCommunities = [];
  List<PostResponse> questionCommunities = [];

  SearchViewModel({required this.repository});

  Future<void> search(String query) async {
    if (query.isEmpty) return;


    try {
      final result = await repository.searchResult(query);

      products = result.products;
      communities = result.community;
      recommendCommunities = communities.where(
              (e) => e.category == 'coord_recommend').toList();
      questionCommunities = communities.where(
              (e) => e.category == 'coord_question').toList();
      
      notifyListeners();
    } catch (e, stack) {
      print("스택 확인 \n ${stack}");
    print(' 검색중 오류 발생: $e');
    }
  }


}