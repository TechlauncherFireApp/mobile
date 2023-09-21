import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:injectable/injectable.dart';

@injectable
class SchedulerConstraintFormClient {

  final RestClient restClient;
  SchedulerConstraintFormClient(this.restClient);

  Future<List<AssetType>> getAssetType() {
    return restClient.getAssetTypes();
  }
}