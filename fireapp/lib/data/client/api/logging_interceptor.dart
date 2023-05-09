
import 'package:dio/dio.dart';
import 'package:fireapp/global/di.dart';
import 'package:injectable/injectable.dart';

@injectable
class HttpLoggingInterceptor extends InterceptorsWrapper {

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d("Response: $response");
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d("Request: ${options.uri}\n${options.data}");
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e(err);
    super.onError(err, handler);
  }

}