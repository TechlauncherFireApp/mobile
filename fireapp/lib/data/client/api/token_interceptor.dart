import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

@injectable
class TokenInterceptor extends InterceptorsWrapper {

  static const authorizationHeader = "Authorization";

  final AuthenticationPersistence _authenticationPersistence;
  TokenInterceptor(this._authenticationPersistence);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var token = _authenticationPersistence.token;
    if (token == null) return handler.next(options);

    options.headers[authorizationHeader] = "Bearer ${_authenticationPersistence.token}";
    handler.next(options);
  }

}