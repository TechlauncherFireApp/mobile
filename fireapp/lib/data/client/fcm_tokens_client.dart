import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/fcm_tokens.dart';

@injectable
class FCMTokensClient {
  final RestClient restClient;

  FCMTokensClient(this.restClient);

  Future<void> registerFCMTokens(FCMTokens tokens) async {
    restClient.registerFCMTokens(tokens);
  }
  Future<void> unregisterFCMTokens(FCMTokens tokens) async {
    restClient.unregisterFCMTokens(tokens);
  }
}
