import 'package:dio/dio.dart';
import 'package:fireapp/data/client/api/json_header_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsonHeaderInterceptor', () {
    test('onRequest sets content type to application/json', () {
      // Arrange
      final interceptor = JsonHeaderInterceptor();
      final options = RequestOptions();

      // Act
      interceptor.onRequest(options, RequestInterceptorHandler());

      // Assert
      expect(options.contentType, equals('application/json'));
    });

    // Add more tests if needed
  });
}
