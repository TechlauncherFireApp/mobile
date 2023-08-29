import 'package:dio/dio.dart';
import 'package:fireapp/data/client/api/base_url_interceptor.dart';
import 'package:fireapp/domain/repository/app_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<AppConfigRepository>(),
])
import 'base_url_interceptor_test.mocks.dart';

void main() {
  group('BaseUrlInterceptor', () {
    late BaseUrlInterceptor baseUrlInterceptor;
    late AppConfigRepository appConfigRepository;

    setUp(() {
      appConfigRepository = MockAppConfigRepository();
      baseUrlInterceptor = BaseUrlInterceptor(appConfigRepository);
    });

    test('should set baseUrl to replaceableHost if serverUrl is null', () {
      final options = RequestOptions(path: '/api/endpoint');

      baseUrlInterceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.baseUrl, BaseUrlInterceptor.replaceableHost);
    });

    test('should set baseUrl to serverUrl if it is not null', () {
      const serverUrl = 'https://api.example.com';
      when(appConfigRepository.getServerUrl()).thenReturn(serverUrl);
      final options = RequestOptions(path: '/api/endpoint');

      baseUrlInterceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.baseUrl, serverUrl);
    });
  });
}