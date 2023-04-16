import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/authentication_client.dart';
import 'package:fireapp/domain/models/token_request.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<RestClient>(),
])
import 'authentication_client_test.mocks.dart';

void main() {
  late AuthenticationClient authenticationClient;
  late MockRestClient restClient;

  setUp(() {
    restClient = MockRestClient();
    authenticationClient = AuthenticationClient(restClient);
  });

  test('login returns token response on successful request', () async {
    // Arrange
    final email = 'test@example.com';
    final password = 'password';
    final token = 'abc123';
    final tokenResponse = TokenResponse(
      userId: 1,
      accessToken: token,
      role: ""
    );
    final request = TokenRequest(email: email, password: password);

    when(restClient.login(request)).thenAnswer((_) async => tokenResponse);

    // Act
    final result = await authenticationClient.login(email, password);

    // Assert
    expect(result, equals(tokenResponse));
    verify(restClient.login(TokenRequest(email: email, password: password)));
  });

  test('login throws error on failed request', () async {
    // Arrange
    final email = 'test@example.com';
    final password = 'password';
    final request = TokenRequest(email: email, password: password);
    final exception = Exception('Failed to login');

    when(restClient.login(request)).thenThrow(exception);

    // Act
    final call = authenticationClient.login(email, password);

    // Assert
    expect(call, throwsA(exception));
    verify(restClient.login(TokenRequest(email: email, password: password)));
  });
}
