import 'package:fireapp/data/client/fcm_token_client.dart';
import 'package:fireapp/domain/repository/notification_fcm_token_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import '../models/notification/fcm_token.dart';
import '../repository/authentication_repository.dart';


@injectable
class RegisterCurrentTokenUseCase {
  final NotificationFCMTokenRepository _notificationTokenRepository;

  RegisterCurrentTokenUseCase(this._notificationTokenRepository);

  void call() async {
    // <get the token and pass it to the repository>

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null || fcmToken.isEmpty) {
      throw Exception("FCM Token is null or empty.");
    }


    _notificationTokenRepository.registerFCMToken(fcmToken);
  }
}
