import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/global/access.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthenticationPersistence {

  TokenResponse? _cached;
  String? get token => _cached?.accessToken;

  Future<void> set(TokenResponse auth) async {
    _cached = auth;

    // LEGACY
    accessToken = auth.accessToken;
    userId = auth.userId;
    role = auth.role;
  }

  Future<TokenResponse?> get() async {
    return _cached;
  }

}