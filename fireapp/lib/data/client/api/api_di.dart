
import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

@module
abstract class APIDependencyInjection {

  @singleton
  Dio get dio => Dio();

  @singleton
  RestClient createRestClient(Dio dio) {
    return RestClient(dio);
  }

}