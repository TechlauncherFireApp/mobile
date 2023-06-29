
import 'dart:async';

import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/global/access.dart';
import 'package:fireapp/global/di.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:fireapp/presentation/register/register_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/models/reference/gender.dart';

@injectable
class RegisterViewModel
    extends FireAppViewModel
    implements NavigationViewModel<RegisterNavigation> {

  final AuthenticationRepository _authenticationRepository;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  final BehaviorSubject<GenderOption?> _gender = BehaviorSubject();
  Stream<GenderOption?> get gender => _gender.stream;

  final BehaviorSubject<RequestState<void>> _state = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<void>> get state => _state.stream;

  bool obscureText = true;

  final BehaviorSubject<RegisterNavigation> _navigate = BehaviorSubject();
  @override
  Stream<RegisterNavigation> get navigate => _navigate.stream;

  RegisterViewModel(this._authenticationRepository);

  void register() {
    _state.add(RequestState.loading());
    () async {
      try {
        await _authenticationRepository.register(
          email.text,
          password.text,
          firstName.text,
          lastName.text,
          _gender.hasValue ? _gender.value?.gender ?? Gender.other : Gender.other,
          phoneNumber.text
        );
        _navigate.add(const RegisterNavigation.home());
        _state.add(RequestState.success(null));
      } catch (e, stacktrace) {
        logger.e("$e $stacktrace");
        _state.add(RequestState.exception(e));
      }
    }();
  }

  void toggleObscureText() => obscureText = !obscureText;
  void setGender(GenderOption? option) => _gender.add(option);
  void navigateToLogin() => _navigate.add(const RegisterNavigation.login());

  @override
  Future<void> dispose() async {
    _navigate.close();
    _state.close();
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    _gender.close();
    phoneNumber.dispose();
  }

}