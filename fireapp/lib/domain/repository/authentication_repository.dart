
import 'package:fireapp/data/client/authentication_client.dart';
import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/exception/signed_out_exception.dart';
import 'package:fireapp/global/access.dart';
import 'package:injectable/injectable.dart';

import '../models/reference/gender.dart';
import '../models/register_request.dart';

/// A repository for handling user authentication.
///
/// This class provides a way to log in and retrieve the current session for a user.
@injectable
class AuthenticationRepository {

  final AuthenticationClient _authenticationClient;
  final AuthenticationPersistence _authenticationPersistence;

  /// Constructs a new [AuthenticationRepository] with the given dependencies.
  ///
  /// The [_authenticationClient] is used to perform login requests, and the [_authenticationPersistence] is used to
  /// store and retrieve the current session token.
  AuthenticationRepository(this._authenticationClient,
      this._authenticationPersistence);

  /// Logs in a user with the given email and password.
  ///
  /// Returns a [TokenResponse] containing the session token.
  Future<TokenResponse> login(String email, String password) async {
    TokenResponse response = await _authenticationClient.login(email, password);
    userEmail = email;
    _authenticationPersistence.set(response);
    return response;
  }

  Future<TokenResponse> register(
      String email,
      String password,
      String firstName,
      String lastName,
      Gender gender,
      String? phoneNumber
  ) async {
    TokenResponse response = await _authenticationClient
        .register(email, password, firstName, lastName, gender, phoneNumber);
    userEmail = email;
    _authenticationPersistence.set(response);
    return response;
  }

  /// Retrieves the current session for the user.
  ///
  /// Returns a [TokenResponse] containing the session token, or `null` if no session is currently active.
  Future<TokenResponse?> getCurrentSession() async {
    return _authenticationPersistence.get();
  }

  Future<void> logout() async {
    _authenticationPersistence.logout();
  }

  Future<int> getUserId() async {
    final session = await _authenticationPersistence.get();
    final userId = session?.userId;
    if (userId == null) {
      throw SignedOutException('User ID cannot be null.');
    }
    return userId;
  }

}