import 'package:dio/dio.dart';
import 'package:look_talk/model/entity/review_entity.dart';
import '../../core/network/api_result.dart';

class ReviewRepository {
  final Dio _dio;

  ReviewRepository(this._dio);

  Future<ApiResult<void>> createReview({
    required String productId,
    required int rating,
    required String content,
    List<MultipartFile>? imageFiles,
  }) async {
    try {
      final formData = FormData.fromMap({
        'rating': rating,
        'comment': content,
        if (imageFiles != null) 'images': imageFiles,
      });

      final res = await _dio.post('/api/products/$productId/reviews', data: formData);
      return ApiResult.fromVoidResponse(res);
    } catch (e) {
      return ApiResult<void>(
        success: false,
        message: '리뷰 작성 실패',
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  Future<ApiResult<List<ReviewEntity>>> getReviews(String productId) async {
    try {
      final res = await _dio.get('/api/products/$productId/reviews');

      final result = ApiResult.fromResponse<List<ReviewEntity>>(res, (data) {
        final items = (data as Map<String, dynamic>)['items'] as List<dynamic>;
        return items.map((e) => ReviewEntity.fromJson(e)).toList();
      });

      return result;
    } catch (e) {
      return ApiResult(
        success: false,
        message: '리뷰 불러오기 실패',
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  Future<ApiResult<double>> getAverageRating(String productId) async {
    try {
      final res = await _dio.get('/api/products/$productId/reviews/average');

      final resultMap = res.data['message']?['result'];
      final average = (resultMap?['averageRating'] ?? 0).toDouble();

      return ApiResult(
        success: true,
        message: '평균 평점 조회 성공',
        data: average,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return ApiResult(
        success: false,
        message: '평균 평점 조회 실패',
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }


  Future<ApiResult<void>> updateReview({
    required String reviewId,
    required int rating,
    required String content,
    List<MultipartFile>? newImages,
  }) async {
    try {
      final formData = FormData.fromMap({
        'rating': rating,
        'content': content,
        if (newImages != null) 'images': newImages,
      });

      final res = await _dio.put('/api/reviews/$reviewId', data: formData);
      return ApiResult.fromVoidResponse(res);
    } catch (e) {
      return ApiResult<void>(
        success: false,
        message: '리뷰 수정 실패',
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  Future<ApiResult<void>> deleteReview(String reviewId) async {
    try {
      final res = await _dio.delete('/api/reviews/$reviewId');
      return ApiResult.fromVoidResponse(res);
    } catch (e) {
      return ApiResult<void>(
        success: false,
        message: '리뷰 삭제 실패',
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  Future<ApiResult<void>> deleteReviewImage(String reviewId, String imageId) async {
    try {
      final res = await _dio.delete('/api/reviews/$reviewId/images/$imageId');
      return ApiResult.fromVoidResponse(res);
    } catch (e) {
      return ApiResult<void>(
        success: false,
        message: '리뷰 이미지 삭제 실패',
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  Future<ApiResult<void>> toggleLike(String reviewId) async {
    try {
      final res = await _dio.post('/api/reviews/$reviewId/like-toggle');
      return ApiResult.fromVoidResponse(res);
    } catch (e) {
      return ApiResult<void>(
        success: false,
        message: '리뷰 좋아요 실패',
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }
}
