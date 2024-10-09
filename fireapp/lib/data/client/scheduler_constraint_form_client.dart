import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/new/vehicle_request.dart';
import '../../domain/models/scheduler/new_request.dart';
import '../../domain/models/scheduler/new_request_response.dart';
import '../../domain/models/scheduler/new_shift_request.dart';

@injectable
class SchedulerConstraintFormClient {

  final RestClient restClient;
  SchedulerConstraintFormClient(this.restClient);

  Future<NewRequestResponse> makeNewRequest(NewRequest newRequest){
    return restClient.makeNewRequest(newRequest);
  }

  Future<void> makeVehicleRequest(VehicleRequest vehicleRequest){
    return restClient.makeVehicleRequest(vehicleRequest);
  }

  Future<NewRequestResponse> makeNewShiftRequest(int userId, NewShiftRequest newShiftRequest) {
    return restClient.postShiftRequest(userId, newShiftRequest);
  }
}