import 'package:fireapp/data/client/scheduler_constraint_form_client.dart';
import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:injectable/injectable.dart';

import '../models/new/vehicle_request.dart';
import '../models/scheduler/new_request.dart';
import '../models/scheduler/new_request_response.dart';

@injectable
class SchedulerConstraintFormRepository {
  final SchedulerConstraintFormClient schedulerConstraintFormClient;

  SchedulerConstraintFormRepository(this.schedulerConstraintFormClient);

  Future<NewRequestResponse> makeNewRequest(NewRequest newRequest){
    return schedulerConstraintFormClient.makeNewRequest(newRequest);
  }

  Future<void> makeVehicleRequest(VehicleRequest vehicleRequest){
    return schedulerConstraintFormClient.makeVehicleRequest(vehicleRequest);
  }
}