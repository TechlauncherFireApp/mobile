
abstract class LoginNavigation {
  LoginNavigation._();

  factory LoginNavigation.home() {
    return HomeLoginNavigation();
  }
  factory LoginNavigation.register() {
    return RegisterLoginNavigation();
  }
  factory LoginNavigation.forgotPassword() {
    return ForgotPasswordLoginNavigation();
  }

}

class HomeLoginNavigation extends LoginNavigation {
  HomeLoginNavigation(): super._();
}

class RegisterLoginNavigation extends LoginNavigation {
  RegisterLoginNavigation(): super._();
}

class ForgotPasswordLoginNavigation extends LoginNavigation {
  ForgotPasswordLoginNavigation(): super._();
}