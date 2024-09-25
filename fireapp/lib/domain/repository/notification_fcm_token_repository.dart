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
    var userId = await getUserId();
    var curToken = FCMToken(fcmToken: token, deviceType: deviceType);
    tokenClient.registerFCMToken(userId, curToken);
  }

  Future<void> unregisterToken(String token) async {
    int userId = await getUserId();
    tokenClient.unregisterFCMToken(
        userId, FCMTokenUnregister(fcmToken: token));
  }

  Future<int> getUserId() async {
    final session = await _authenticationRepository.getCurrentSession();
    final userId = session?.userId;

    if (userId == null) {
      throw Exception('User ID is null. Cannot register FCM Token.');
    }
    return userId;
  }
}
