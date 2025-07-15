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

  // ✅ 상품별 찜 상태 저장
  final Map<String, bool> _wishlistStatusMap = {};

  bool get isLoading => _isLoading;
  bool get isFirstLoad => _isFirstLoad;
  String? get error => _error;
  UnmodifiableListView<WishlistItemEntity> get items => UnmodifiableListView(_items);
  bool get hasNext => _pagination?.hasNext ?? false;

  /// ✅ 전체 찜 목록 조회
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

    try {
      final nextPage = (isRefresh || _pagination == null) ? 1 : _pagination!.page + 1;
      final responseDto = await _repository.fetchWishlist(page: nextPage);

      if (isRefresh) _items.clear();

      final newItems = responseDto.items
          .map((dto) => WishlistItemEntity.fromDto(dto))
          .toList();

      _items.addAll(newItems);

      // 찜 상태 Map에도 업데이트
      for (var item in newItems) {
        _wishlistStatusMap[item.productId] = true;
      }

      // _pagination = responseDto.pagination; // TODO: 필요 시 주석 해제
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    _isFirstLoad = false;
    notifyListeners();
  }

  Future<void> refresh() async => await fetchWishlist(isRefresh: true);

  /// ✅ 찜 상태 개별 확인 API 호출
  Future<void> fetchWishlistStatus(String productId) async {
    try {
      final isFavorite = await _repository.checkFavorite(productId);
      _wishlistStatusMap[productId] = isFavorite;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  /// ✅ 현재 상품이 찜되어 있는지 확인
  bool isWishlisted(String productId) {
    return _wishlistStatusMap[productId] ?? false;
  }

  /// ✅ 찜 토글 (추가 또는 삭제)
  Future<void> toggleWishlist(String productId) async {
    try {
      await _repository.toggleFavorite(productId);
      final current = _wishlistStatusMap[productId] ?? false;
      _wishlistStatusMap[productId] = !current;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  /// ✅ 찜 수 (단순하게 찜 여부만 표시하는 경우 1 또는 0 반환)
  int getWishlistCount(String productId) {
    return isWishlisted(productId) ? 1 : 0;
  }

  /// ✅ 찜 목록에서 삭제
  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.productId == productId);
    _wishlistStatusMap[productId] = false;
    notifyListeners();

    try {
      await _repository.removeItem(productId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      await refresh(); // 실패 시 동기화
    }
  }
}
