import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/notification/fcm_token_unregister.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/notification/fcm_token.dart';

@injectable
class FCMTokenClient {
  final RestClient restClient;

  FCMTokenClient(this.restClient);

  Future<void> registerFCMToken(int userId, FCMToken token) async {
    restClient.registerFCMToken(userId, token);
  }
  Future<void> unregisterFCMToken(int userId, FCMTokenUnregister token) async {
    restClient.unregisterFCMToken(userId, token);
  }
}
