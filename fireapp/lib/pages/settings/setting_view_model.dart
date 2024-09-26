import 'dart:async';

import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/repository/notification_fcm_token_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/pages/settings/setting_navigation.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../global/di.dart';

@injectable
class SettingViewModel extends FireAppViewModel
    implements NavigationViewModel<SettingNavigation> {
  final AuthenticationRepository _authenticationRepository;
  final NotificationFCMTokenRepository _fcmTokenRepository;

  final BehaviorSubject<RequestState<void>> _state =
      BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<void>> get state => _state.stream;

  final BehaviorSubject<SettingNavigation> _navigate = BehaviorSubject();
  @override
  Stream<SettingNavigation> get navigate => _navigate.stream;

  SettingViewModel(this._authenticationRepository, this._fcmTokenRepository);

  Future<void> unregisterFcmToken() async {
    var curToken = await FirebaseMessaging.instance.getToken();
    if (curToken == null) {
      throw Exception('FCM token cannot be null');
    }
    await _fcmTokenRepository.unregisterToken(curToken);
  }

  Future<void> signOut() async {
    _state.add(RequestState.loading());
    try {
      await unregisterFcmToken();
      await _authenticationRepository.logout();
      _state.add(RequestState.success(null));
      _navigate.add(SettingNavigation.signOut());
    } catch (e, stacktrace) {
      logger.e("$e $stacktrace");
      _state.add(RequestState.exception(e));
    }
  }

  @override
  Future<void> dispose() async {
    await _navigate.close();
    await _state.close();
  }
}
