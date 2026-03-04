import 'package:dio/dio.dart';
import 'package:random_coffee/core/constants/api_endpoints.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl, //TODO Вынести в .env
        connectTimeout: const Duration(seconds: 15), //TODO убрать эту строку
        receiveTimeout: const Duration(seconds: 15), //TODO убрать эту строку
        sendTimeout: const Duration(seconds: 15), //TODO убрать эту строку
      ),
    );

    // TODO потом убрать
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }

  Dio get dio => _dio;
}
