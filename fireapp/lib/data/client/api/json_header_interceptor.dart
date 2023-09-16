import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:fireapp/domain/repository/app_config_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

@injectable
class JsonHeaderInterceptor extends InterceptorsWrapper {

  JsonHeaderInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.contentType = "application/json";
    handler.next(options);
  }

}