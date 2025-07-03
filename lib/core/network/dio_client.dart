import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://git.hansul.kr:3000/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ))..interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    compact: true,
    maxWidth: 90,
  ));

  static Dio get instance => _dio;
}
