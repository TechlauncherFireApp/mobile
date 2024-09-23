import 'package:fireapp/data/client/fcm_tokens_client.dart';
import 'package:fireapp/domain/models/fcm_tokens.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'authentication_repository.dart';

@injectable
class NotificationFCMTokenRepository {
  final FCMTokenClient tokensClient;
  NotificationFCMTokenRepository(
      this.tokensClient);

  Future<void> registerFCMToken(FCMToken token) async {
    tokensClient.registerFCMToken(token);
  }

  Future<void> unregisterToken(FCMToken token) async {
    tokensClient.unregisterFCMToken(token);
  }
}
