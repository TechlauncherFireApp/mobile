
import 'package:fireapp/data/client/api/logging_interceptor.dart';
import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/api/token_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

@module
abstract class APIDependencyInjection {

  @singleton
  Dio createDio(
      TokenInterceptor tokenInterceptor,
      HttpLoggingInterceptor loggingInterceptor
  ) {
    return Dio()
      ..interceptors.add(loggingInterceptor)
      ..interceptors.add(tokenInterceptor);
  }

  @singleton
  RestClient createRestClient(Dio dio) {
    return RestClient(dio);
  }

}