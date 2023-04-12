import 'package:fireapp/data/client/authentication_client.dart';
import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationClient>(),
  MockSpec<AuthenticationPersistence>(),
])
import 'authentication_repository_test.mocks.dart';

void main() {
  late AuthenticationRepository authenticationRepository;
  late MockAuthenticationClient authenticationClient;
  late MockAuthenticationPersistence authenticationPersistence;

  setUp(() {
    authenticationClient = MockAuthenticationClient();
    authenticationPersistence = MockAuthenticationPersistence();
    authenticationRepository = AuthenticationRepository(authenticationClient, authenticationPersistence);
  });

  group('AuthenticationRepository', () {
    test('login should return token response', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'test_password';
      const tokenResponse = TokenResponse(
        accessToken: 'test_token',
        userId: 1,
        role: "role"
      );
      when(authenticationClient.login(email, password)).thenAnswer((_) async => tokenResponse);

      // Act
      final result = await authenticationRepository.login(email, password);

      // Assert
      expect(result, tokenResponse);
      verify(authenticationPersistence.set(tokenResponse)).called(1);
    });

    test('getCurrentSession should return token response', () async {
      // Arrange
      const tokenResponse = TokenResponse(
        accessToken: 'test_token',
        userId: 1,
        role: "role"
      );
      when(authenticationPersistence.get()).thenAnswer((_) async => tokenResponse);

      // Act
      final result = await authenticationRepository.getCurrentSession();

      // Assert
      expect(result, tokenResponse);
      verify(authenticationPersistence.get()).called(1);
    });
  });
}
