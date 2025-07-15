import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:look_talk/model/entity/review_entity.dart';
import 'package:look_talk/model/repository/review_repository.dart';
import '../../core/network/api_result.dart';

class ReviewViewModel extends ChangeNotifier {
  final ReviewRepository _repository;
  bool _disposed = false;

  ReviewViewModel(this._repository);

  List<ReviewEntity> _reviews = [];
  double _averageRating = 0.0;
  bool _isLoading = false;

  List<ReviewEntity> get reviews => _reviews;
  double get averageRating => _averageRating;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  Future<void> fetchReviewsAndAverage(String productId) async {
    _isLoading = true;
    _safeNotifyListeners();

    final reviewsResult = await _repository.getReviews(productId);
    final averageResult = await _repository.getAverageRating(productId);

    if (reviewsResult.success && reviewsResult.data != null) {
      _reviews = reviewsResult.data!;
    }

    if (averageResult.success && averageResult.data != null) {
      _averageRating = averageResult.data!;
    }

    _isLoading = false;
    _safeNotifyListeners();
  }

  Future<ApiResult<void>> createReview({
    required String productId,
    required int rating,
    required String content,
    List<MultipartFile>? imageFiles,
  }) async {
    final result = await _repository.createReview(
      productId: productId,
      rating: rating,
      content: content,
      imageFiles: imageFiles,
    );

    if (result.success) {
      await fetchReviewsAndAverage(productId);
    }

    return result;
  }

  Future<void> toggleReviewLike(String reviewId) async {
    final result = await _repository.toggleLike(reviewId);
    if (result.success) {
      final productId = _reviews.firstWhere((r) => r.id == reviewId).productId;
      await fetchReviewsAndAverage(productId);
    }
  }

  Future<ApiResult<void>> deleteReview(String reviewId) async {
    final result = await _repository.deleteReview(reviewId);
    if (result.success) {
      _reviews.removeWhere((r) => r.id == reviewId);
      _averageRating = _calculateAverage();
      _safeNotifyListeners();
    }
    return result;
  }

  double _calculateAverage() {
    if (_reviews.isEmpty) return 0.0;
    final total = _reviews.map((e) => e.rating).reduce((a, b) => a + b);
    return total / _reviews.length;
  }
}
