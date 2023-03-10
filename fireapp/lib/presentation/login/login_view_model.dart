
import 'dart:async';

import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends FireAppViewModel {

  final AuthenticationRepository _authenticationRepository;

  final StreamController<bool> _obscureText = StreamController();

  LoginViewModel(this._authenticationRepository);

  void login(String email, String password) {
    _authenticationRepository.login(email, password).then((value) => {

    });
  }

  @override
  Future<void> dispose() async {
    _obscureText.close();
  }

}