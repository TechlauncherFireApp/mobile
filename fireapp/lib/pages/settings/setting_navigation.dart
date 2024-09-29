abstract class SettingNavigation {
  SettingNavigation._();

  factory SettingNavigation.login() {
    return LoginSettingNavigation();
  }
}

class LoginSettingNavigation extends SettingNavigation {
  LoginSettingNavigation() : super._();
}