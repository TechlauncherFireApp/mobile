import 'dart:async';

import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/repository/notification_fcm_token_repository.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:fireapp/presentation/login/login_navigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/notification/fcm_token.dart';

@injectable
class SettingViewModel {
  final AuthenticationRepository _authenticationRepository;
  final NotificationFCMTokenRepository _fcmTokenRepository;
  SettingViewModel(this._authenticationRepository, this._fcmTokenRepository);

  Future<void> unregisterFcmToken() async {
    var curToken = await FirebaseMessaging.instance.getToken();
    if (curToken == null) {
      throw Exception('FCM token cannot be null');
    }
    _fcmTokenRepository.unregisterToken(curToken);
  }
}
