import 'package:dio/dio.dart';
import 'package:serv_sync/core/exceptions/base_exception.dart';

class NetworkException extends BaseException {
  NetworkException()
      : super(
          DioExceptionType.connectionError.toString(),
        );
}
