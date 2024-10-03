import 'package:fireapp/domain/repository/shifts_repository.dart';
import 'package:fireapp/global/access.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/models/shift.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/request_state.dart';
import '../../global/di.dart';
import 'domain/models/notification/fcm_token.dart';
import 'domain/repository/notification_fcm_token_repository.dart';

@injectable
class MainViewModel {
  late final AuthenticationRepository _authenticationRepository;
  late final NotificationFCMTokenRepository _fcmTokenRepository;

  MainViewModel(this._authenticationRepository, this._fcmTokenRepository);

  Future<void> setupTokenListener() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      var userID =
          await _authenticationRepository.getUserId();
      if (userID != null) {
        _fcmTokenRepository
            .registerFCMToken(newToken);
      }
    });
  }
}
