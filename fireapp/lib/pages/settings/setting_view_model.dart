import 'dart:async';

import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/repository/notification_fcm_token_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';


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
    await _fcmTokenRepository.unregisterToken(curToken);
  }

  Future<void> signOut(BuildContext context) async {
    await unregisterFcmToken();
    await _authenticationRepository.logout();
    Navigator.popUntil(context, (route) => true);
    Navigator.pushNamed(context, "/login");
  }
}
