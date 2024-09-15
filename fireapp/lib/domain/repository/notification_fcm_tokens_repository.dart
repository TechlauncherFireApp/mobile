import 'package:fireapp/data/client/fcm_tokens_client.dart';
import 'package:fireapp/domain/models/fcm_tokens.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';


@injectable
class NotificationFCMTokensRepository {
  final FCMTokensClient tokensClient;
  NotificationFCMTokensRepository(this.tokensClient);

  Future<void> registerFCMTokens(int userId) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null || fcmToken.isEmpty) {
      throw Exception("FCM Token is null or empty.");
    }

    String deviceType;
    if (Platform.isAndroid) {
      deviceType = 'android';
    } else if (Platform.isIOS) {
      deviceType = 'ios';
    } else {
      deviceType = 'other';
    }

    DateTime creationTime = DateTime.now();
    DateTime updateTime = DateTime.now();
    int isActive = 1;

    await tokensClient.registerFCMTokens(
      FCMTokens(
        userId: userId,
        fcmToken: fcmToken,
        deviceType: deviceType,
        creationTime: creationTime,
        updateTime: updateTime,
        isActive: isActive,
      ),
    );
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      DateTime newUpdateTime = DateTime.now();
      await tokensClient.registerFCMTokens(
        FCMTokens(
          userId: userId,
          fcmToken: newToken,
          deviceType: deviceType,
          creationTime: creationTime,  
          updateTime: newUpdateTime,  
          isActive: isActive,
        ),
      );
    });

  }

  Future<void> unregisterToken(int userId) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null || fcmToken.isEmpty) {
      return;
    }
    await tokensClient.unregisterFCMTokens(
      FCMTokens(userId: userId, fcmToken: fcmToken)
    );
  }
}