import 'package:fireapp/data/client/scheduler_constraint_form_client.dart';
import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:injectable/injectable.dart';

@injectable
class SchedulerConstraintFormRepository {
  final SchedulerConstraintFormClient schedulerConstraintFormClient;

  SchedulerConstraintFormRepository(this.schedulerConstraintFormClient);

  Future<List<AssetType>> getAssetType(int id,
      String name,
      String code,
      DateTime updated,
      DateTime created) {
    return schedulerConstraintFormClient.getAssetType();
  }
}