import 'package:fireapp/data/client/api/token_interceptor.dart';
import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationPersistence>(),
])
import 'token_interceptor_test.mocks.dart';

void main() {
  group('TokenInterceptor', () {
    late TokenInterceptor tokenInterceptor;
    late MockAuthenticationPersistence authenticationPersistenceMock;

    setUp(() {
      authenticationPersistenceMock = MockAuthenticationPersistence();
      tokenInterceptor = TokenInterceptor(authenticationPersistenceMock);
    });

    test('should add authorization header when token is present', () async {
      // arrange
      final options = RequestOptions(path: 'test');
      when(authenticationPersistenceMock.token).thenReturn('testToken');

      // act
      tokenInterceptor.onRequest(options, RequestInterceptorHandler());

      // assert
      expect(options.headers[TokenInterceptor.authorizationHeader], equals('Bearer testToken'));
    });

    test('should not add authorization header when token is null', () async {
      // arrange
      final options = RequestOptions(path: 'test');
      when(authenticationPersistenceMock.token).thenReturn(null);

      // act
      tokenInterceptor.onRequest(options, RequestInterceptorHandler());

      // assert
      expect(options.headers.containsKey(TokenInterceptor.authorizationHeader), isFalse);
    });
  });
}
