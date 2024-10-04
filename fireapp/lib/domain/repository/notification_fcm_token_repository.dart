import 'package:fireapp/data/client/fcm_token_client.dart';
import 'package:fireapp/domain/models/notification/fcm_token_unregister.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import '../../exception/signed_out_exception.dart';
import '../models/notification/fcm_token.dart';
import 'authentication_repository.dart';
import 'device_repository.dart';

@injectable
class NotificationFCMTokenRepository {

  final FCMTokenClient tokenClient;
  final AuthenticationRepository _authenticationRepository;
  final DeviceRepository _deviceRepository;

  NotificationFCMTokenRepository(
      this.tokenClient, this._authenticationRepository, this._deviceRepository);

  Future<void> registerFCMToken(String token) async {
    String deviceType = (await _deviceRepository.getDeviceType()).name;
    int? userId = await _authenticationRepository.getUserId();
    if (userId == null) {
      throw SignedOutException('A user ID cannot be null.');
    }
    var curToken = FCMToken(fcmToken: token, deviceType: deviceType);
    tokenClient.registerFCMToken(userId, curToken);
  }

  Future<void> unregisterToken(String token) async {
    int? userId = await _authenticationRepository.getUserId();
    if (userId == null) {
      throw SignedOutException('A user ID cannot be null.');
    }
    await tokenClient.unregisterFCMToken(
        userId, FCMTokenUnregister(fcmToken: token));
  }
}
