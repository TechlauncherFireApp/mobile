abstract class SettingNavigation {
  SettingNavigation._();

  factory SettingNavigation.signOut() {
    return SignOutNavigation();
  }
}

class SignOutNavigation extends SettingNavigation {
  SignOutNavigation() : super._();
}