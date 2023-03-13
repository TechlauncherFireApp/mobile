
import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/token_request.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthenticationClient {

  final RestClient restClient;
  AuthenticationClient(this.restClient);

  /// Sends a login request to the API using the provided [email] and [password].
  ///
  /// Returns a [TokenResponse] object that contains the token received from the server.
  /// Throws an error if the request fails or the response is invalid.x
  Future<TokenResponse> login(String email, String password) async {
    return restClient.login(TokenRequest(
        email: email,
        password: password
    ));
  }

}