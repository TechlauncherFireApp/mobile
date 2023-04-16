import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/authentication_client.dart';
import 'package:fireapp/domain/models/reference/gender.dart';
import 'package:fireapp/domain/models/register_request.dart';
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

  test('register returns token response on successful request', () async {
    // Arrange
    const email = 'test@example.com';
    const password = 'test_password';
    const firstName = 'name';
    const lastName = 'name';
    const gender = Gender.other;
    const phoneNumber = "0212321123";
    const tokenResponse = TokenResponse(
        accessToken: 'test_token',
        userId: 1,
        role: "role"
    );
    const registerRequest = RegisterRequest(
      email: email, 
      password: password, 
      firstName: firstName, 
      lastName: lastName, 
      gender: gender
    );
    when(restClient.register(registerRequest)).thenAnswer((_) async => tokenResponse);

    // Act
    final result = await authenticationClient.register(
        email,
        password,
        firstName,
        lastName,
        gender,
        phoneNumber
    );

    // Assert
    expect(result, tokenResponse);
    verify(restClient.register(registerRequest)).called(1);
  });
}
