
import 'dart:async';

import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class LoginViewModel extends FireAppViewModel {

  final AuthenticationRepository _authenticationRepository;

  final BehaviorSubject<bool> _obscureText = BehaviorSubject.seeded(true);
  Stream<bool> get obscureText => _obscureText.stream;

  final BehaviorSubject<void> _proceed = BehaviorSubject();

  LoginViewModel(this._authenticationRepository);

  void login(String email, String password) {
    () async {
      try {
        await _authenticationRepository.login(email, password);
        _proceed.add(null);
      } catch (e) {
        logger.e(e);
      }
    }();
  }

  void toggleObscureText() => _obscureText.add(!_obscureText.value);

  @override
  Future<void> dispose() async {
    _obscureText.close();
  }

}