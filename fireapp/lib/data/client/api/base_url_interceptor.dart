import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:fireapp/domain/repository/app_config_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

@injectable
class BaseUrlInterceptor extends InterceptorsWrapper {

  static const replaceableHost = "https://replaceable";

  final AppConfigRepository _appConfigRepository;
  BaseUrlInterceptor(this._appConfigRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.baseUrl = _appConfigRepository.getServerUrl() ?? replaceableHost;
    handler.next(options);
  }

}