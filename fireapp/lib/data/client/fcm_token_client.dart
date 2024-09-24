import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/fcm_token.dart';

@injectable
class FCMTokenClient {
  final RestClient restClient;

  FCMTokenClient(this.restClient);

  Future<void> registerFCMToken(FCMToken tokens) async {
    restClient.registerFCMToken(tokens.userId, tokens);
  }
  Future<void> unregisterFCMToken(FCMToken tokens) async {
    restClient.unregisterFCMToken(tokens.userId, tokens);
  }
}
