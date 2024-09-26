import 'package:fireapp/data/client/fcm_token_client.dart';
import 'package:fireapp/domain/models/notification/fcm_token_unregister.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import '../models/notification/fcm_token.dart';
import 'authentication_repository.dart';

@injectable
class NotificationFCMTokenRepository {
  final FCMTokenClient tokenClient;
  final AuthenticationRepository _authenticationRepository;
  NotificationFCMTokenRepository(
      this.tokenClient, this._authenticationRepository);

  Future<void> registerFCMToken(String token) async {
    String deviceType = 'android';
    var userId = await _authenticationRepository.getUserId();
    var curToken = FCMToken(fcmToken: token, deviceType: deviceType);
    tokenClient.registerFCMToken(userId, curToken);
  }

  Future<void> unregisterToken(String token) async {
    int userId = await _authenticationRepository.getUserId();
    await tokenClient.unregisterFCMToken(
        userId, FCMTokenUnregister(fcmToken: token));
  }
}
