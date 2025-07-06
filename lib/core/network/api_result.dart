class ApiResult<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  ApiResult.success(this.data)
      : isSuccess = true,
        errorMessage = null;

  ApiResult.failure(this.errorMessage)
      : isSuccess = false,
        data = null;

  // static constructor from Dio Response
  static ApiResult<T> fromResponse<T>(
      dynamic response,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    try {
      final map = response.data as Map<String, dynamic>;
      final success = map['success'] as bool? ?? false;

      if (success) {
        final dataMap = map['data'] as Map<String, dynamic>;
        final data = fromJson(dataMap);
        return ApiResult.success(data);
      } else {
        return ApiResult.failure(map['message'] ?? '알 수 없는 오류');
      }
    } catch (e) {
      return ApiResult.failure('파싱 중 오류 발생: $e');
    }
  }

  void when({
    required Function(T data) success,
    required Function(ApiResult<T> failure) error,
  }) {
    if (isSuccess && data != null) {
      success(data!);
    } else {
      error(this);
    }
  }
}
