
import 'package:fireapp/data/client/authentication_client.dart';
import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:injectable/injectable.dart';

/// A repository for handling user authentication.
///
/// This class provides a way to log in and retrieve the current session for a user.
@injectable
class AuthenticationRepository {

  final AuthenticationClient authenticationClient;
  final AuthenticationPersistence authenticationPersistence;

  /// Constructs a new [AuthenticationRepository] with the given dependencies.
  ///
  /// The [authenticationClient] is used to perform login requests, and the [authenticationPersistence] is used to
  /// store and retrieve the current session token.
  AuthenticationRepository(this.authenticationClient,
      this.authenticationPersistence);

  /// Logs in a user with the given email and password.
  ///
  /// Returns a [TokenResponse] containing the session token.
  Future<TokenResponse> login(String email, String password) async {
    TokenResponse response = await authenticationClient.login(email, password);
    authenticationPersistence.set(response);
    return response;
  }

  /// Retrieves the current session for the user.
  ///
  /// Returns a [TokenResponse] containing the session token, or `null` if no session is currently active.
  Future<TokenResponse?> getCurrentSession() async {
    return authenticationPersistence.get();
  }
}