import 'package:fireapp/domain/models/token_response.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthenticationPersistence {

  TokenResponse? _cached;

  Future<void> set(TokenResponse auth) async {
    _cached = auth;
  }

  Future<TokenResponse?> get() async {
    return _cached;
  }

}