
import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/token_request.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthenticationClient {

  final RestClient restClient;
  AuthenticationClient(this.restClient);

  Future<TokenResponse> login(String email, String password) async {
    return restClient.login(TokenRequest(
        email: email,
        password: password
    ));
  }

}