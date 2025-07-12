import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/pagination_entity.dart';
import 'package:look_talk/model/entity/wishlist_dto.dart';
import 'package:look_talk/model/entity/wishlist_entity.dart';
import 'package:look_talk/model/repository/wishlist_repository.dart';

class WishlistViewModel extends ChangeNotifier {
  final WishlistRepository _repository;

  WishlistViewModel(this._repository);

  bool _isLoading = false;
  bool _isFirstLoad = true;
  String? _error;
  List<WishlistItemEntity> _items = [];
  Pagination? _pagination;

  bool get isLoading => _isLoading;
  bool get isFirstLoad => _isFirstLoad;
  String? get error => _error;
  UnmodifiableListView<WishlistItemEntity> get items => UnmodifiableListView(_items);
  bool get hasNext => _pagination?.hasNext ?? false;

  Future<void> fetchWishlist({bool isRefresh = false}) async {
    if (_isLoading || (!hasNext && !isRefresh && !_isFirstLoad)) return;

    _isLoading = true;
    if (isRefresh) {
      _items.clear();
      _pagination = null;
      _isFirstLoad = true;
    }
    if (_isFirstLoad || isRefresh) {
      notifyListeners();
    }

    // [수정] Repository가 Exception을 던지므로 try-catch로 감싸서 오류를 처리합니다.
    try {
      final nextPage = (isRefresh || _pagination == null) ? 1 : _pagination!.page + 1;
      // Repository는 이제 ApiResult 대신 WishlistResponseDto를 직접 반환합니다.
      final responseDto = await _repository.fetchWishlist(page: nextPage);

      if (isRefresh) _items.clear();

      final newItems = responseDto.items
          .map((dto) => WishlistItemEntity.fromDto(dto))
          .toList();

      _items.addAll(newItems);
      // _pagination = responseDto.pagination; // TODO: DTO에 pagination이 있다면 주석 해제
      _error = null;

    } catch (e) {
      // Repository에서 던진 오류를 여기서 처리합니다.
      _error = e.toString();
    }

    _isLoading = false;
    _isFirstLoad = false;
    notifyListeners();
  }

  Future<void> refresh() async => await fetchWishlist(isRefresh: true);

  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();

    try {
      await _repository.removeItem(productId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      // 실패 시 목록을 다시 불러와 동기화
      await refresh();
    }
  }
}