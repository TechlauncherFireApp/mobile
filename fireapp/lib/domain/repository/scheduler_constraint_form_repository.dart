import 'package:fireapp/data/client/scheduler_constraint_form_client.dart';
import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:fireapp/exception/signed_out_exception.dart';
import 'package:injectable/injectable.dart';

import '../../exception/null_user_id_shift_exception.dart';
import '../models/new/vehicle_request.dart';
import '../models/scheduler/new_request.dart';
import '../models/scheduler/new_request_response.dart';
import '../models/scheduler/new_shift_request.dart';
import 'authentication_repository.dart';

@injectable
class SchedulerConstraintFormRepository {
  final SchedulerConstraintFormClient schedulerConstraintFormClient;
  final AuthenticationRepository _authenticationRepository;

  SchedulerConstraintFormRepository(this.schedulerConstraintFormClient, this._authenticationRepository);

  Future<NewRequestResponse> makeNewRequest(NewRequest newRequest){
    return schedulerConstraintFormClient.makeNewRequest(newRequest);
  }

  Future<void> makeVehicleRequest(VehicleRequest vehicleRequest){
    return schedulerConstraintFormClient.makeVehicleRequest(vehicleRequest);
  }

  Future<NewRequestResponse> makeNewShiftRequest(
    String title,
    int vehicleTypeId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Fetch the userId from the authentication repository
    int? userId = await _authenticationRepository.getUserId();
    if (userId == null) {
      throw SignedOutException("User Id is null while trying to make new shift request");
    }
    // Create the NewShiftRequest object
    NewShiftRequest newShiftRequest = NewShiftRequest(
      title: title,
      vehicleType: vehicleTypeId,
      startTime: startDate,
      endTime: endDate,
    );

    // Make the request using the client
    return schedulerConstraintFormClient.makeNewShiftRequest(userId, newShiftRequest);
  }
}