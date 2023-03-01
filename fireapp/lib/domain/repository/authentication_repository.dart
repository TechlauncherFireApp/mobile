
import 'package:fireapp/data/client/authentication_client.dart';
import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthenticationRepository {

  final AuthenticationClient authenticationClient;
  final AuthenticationPersistence authenticationPersistence;

  AuthenticationRepository(this.authenticationClient, this.authenticationPersistence);

  Future<TokenResponse> login(String email, String password) async {
    TokenResponse response = await authenticationClient.login(email, password);
    authenticationPersistence.set(response);
    return response;
  }

  Future<TokenResponse?> getCurrentSession() async {
    return authenticationPersistence.get();
  }

}