import 'dart:collection';
import 'package:flutter/material.dart';
import '../../model/entity/response/pagination_entity.dart'; // [✅ 수정] 올바른 경로로 수정
import '../../model/entity/response/wishlist_response.dart';
import '../../model/repository/wishlist_repository.dart';

class WishlistViewModel extends ChangeNotifier {
  final WishlistRepository _repository;

  WishlistViewModel(this._repository) {
    print("--- [WishlistViewModel] C R E A T E D ---");
  }

  // --- 상태 변수 및 Getters (이전과 동일) ---
  bool _isLoading = false;
  bool _isFirstLoad = true;
  String? _error;
  Pagination? _pagination;
  final List<WishlistItem> _items = [];

  bool get isLoading => _isLoading;
  bool get isFirstLoad => _isFirstLoad;
  String? get error => _error;
  UnmodifiableListView<WishlistItem> get items => UnmodifiableListView(_items);
  bool get hasNext => _pagination?.hasNext ?? false;

  // --- 함수 (이전과 동일) ---
  Future<void> fetchWishlist({bool isRefresh = false}) async {
    print("--- [WishlistViewModel] fetchWishlist() CALLED ---");
    if (_isLoading) return;
    if (!hasNext && !isRefresh && !_isFirstLoad) return;

    _isLoading = true;
    if (isRefresh) {
      _items.clear();
      _pagination = null;
      _isFirstLoad = true;
    }
    notifyListeners(); // isFirstLoad가 아닐 때만 호출하는 것보다, 로딩 상태를 즉시 반영하기 위해 여기서 호출

    final nextPage = (isRefresh || _pagination == null) ? 1 : _pagination!.page + 1;
    print('[WishlistViewModel] 찜 목록 불러오기 시작... (페이지: $nextPage)');

    final result = await _repository.fetchWishlist(page: nextPage);
    print('[WishlistViewModel] API 응답 받음: success=${result.success}');

    if (result.success && result.data != null) {
      _items.addAll(result.data!.items);
      _pagination = result.data!.pagination;
      _error = null;
      print('[WishlistViewModel] 성공: 아이템 ${result.data!.items.length}개 추가됨. 총 아이템 수: ${_items.length}');
    } else {
      _error = result.message;
      print('[WishlistViewModel] 실패: ${result.message}');
    }

    _isLoading = false;
    _isFirstLoad = false;
    notifyListeners();
  }


  /// 새로고침
  Future<void> refresh() async {
    await fetchWishlist(isRefresh: true);
  }

  /// 찜 아이템 추가
  Future<void> addItem(String productId) async {
    final result = await _repository.addItem(productId);
    if (result.success) {
      await refresh();
    } else {
      print('찜 추가 실패: ${result.message}');
    }
  }

  /// 찜 아이템 삭제
  Future<void> removeItem(String productId) async {
    final result = await _repository.removeItem(productId);
    if (result.success) {
      _items.removeWhere((item) => item.id == productId);
      notifyListeners();
    } else {
      print('삭제 실패: ${result.message}');
    }
  }
}