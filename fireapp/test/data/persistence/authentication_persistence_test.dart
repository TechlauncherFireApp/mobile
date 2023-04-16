import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fireapp/domain/models/token_response.dart';

void main() {
  group('AuthenticationPersistence', () {
    late AuthenticationPersistence authenticationPersistence;

    setUp(() {
      authenticationPersistence = AuthenticationPersistence();
    });

    test('token is null initially', () {
      expect(authenticationPersistence.token, isNull);
    });

    test('set() and get() work correctly', () async {
      const tokenResponse = TokenResponse(
        userId: 1,
        accessToken: 'test_token',
        role: ""
      );
      await authenticationPersistence.set(tokenResponse);

      final cachedToken = await authenticationPersistence.get();

      expect(cachedToken, equals(tokenResponse));
      expect(authenticationPersistence.token, equals('test_token'));
    });
  });
}