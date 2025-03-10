import 'package:dio/dio.dart';
import 'package:serv_sync/core/exceptions/api_exception.dart';
import 'package:serv_sync/core/exceptions/network_exception.dart';
import 'package:serv_sync/core/exceptions/unhandled_exception.dart';
import 'package:serv_sync/core/logging/logger.dart';
import 'package:serv_sync/core/network/intercetors/network_interceptor.dart';
import 'package:serv_sync/core/network/intercetors/error_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: "http://86.123.235.136:8080/",
            connectTimeout: Duration(seconds: 10),
            receiveTimeout: Duration(seconds: 10),
            headers: {"Content-Type": "application/json"},
          ),
        ) {
    // Add Interceptors
    _dio.interceptors.addAll(
      [
        TalkerDioLogger(
          talker: Logger.instance,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printResponseData: false,
            hiddenHeaders: {'Authorization'},
          ),
        ),
        NetworkInterceptor(),
        ErrorInterceptor(),
      ],
    );
  }
  /// Convenience method to make an HTTP POST request.
  Future<Response<T>> post<T>(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async{
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e, trace) {
      Logger.instance.error(e.message, e, trace);
      if (e.type == DioExceptionType.badResponse) {
        throw ApiException(e.message ?? '');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw NetworkException();
      }
      throw UnhandledException(e.message ?? '');
    } catch (e, trace) {
      Logger.instance.error(e.toString(), e, trace);
      throw Exception(e.toString());
    }
  }
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e, trace) {
      Logger.instance.error(e.message, e, trace);
      if (e.type == DioExceptionType.badResponse) {
        throw ApiException(e.message ?? '');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw NetworkException();
      }
      throw UnhandledException(e.message ?? '');
    } catch (e, trace) {
      Logger.instance.error(e.toString(), e, trace);
      throw Exception(e.toString());
    }
  }
}
