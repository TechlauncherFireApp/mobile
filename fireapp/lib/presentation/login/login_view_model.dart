import 'dart:async';

import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/repository/notification_fcm_token_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/access.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:fireapp/presentation/login/login_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/use_cases/register_token_use_case.dart';

@injectable
class LoginViewModel
    extends FireAppViewModel
    implements NavigationViewModel<LoginNavigation> {

  final AuthenticationRepository _authenticationRepository;
  final RegisterCurrentTokenUseCase _registerCurrentTokenUseCase;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final BehaviorSubject<RequestState<void>> _state = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<void>> get state => _state.stream;

  bool obscureText = true;

  final BehaviorSubject<LoginNavigation>  _navigate = BehaviorSubject();
  @override
  Stream<LoginNavigation> get navigate => _navigate.stream;

  LoginViewModel(this._authenticationRepository, this._registerCurrentTokenUseCase);

  void login() {
    _state.add(RequestState.loading());
    () async {
      try {
        await _authenticationRepository.login(email.text, password.text);
        _registerCurrentTokenUseCase();
        _navigate.add(LoginNavigation.home());
        _state.add(RequestState.success(null));
      } catch (e, stacktrace) {
        logger.e("$e $stacktrace");
        _state.add(RequestState.exception(e));
      }
    }();
  }

  void toggleObscureText() => obscureText = !obscureText;

  void navigateToRegister() {
    _navigate.add(RegisterLoginNavigation());
  }

  void navigateToForgotPassword() {
    _navigate.add(ForgotPasswordLoginNavigation());
  }

  @override
  Future<void> dispose() async {
    _navigate.close();
    _state.close();
    email.dispose();
    password.dispose();
  }
}
