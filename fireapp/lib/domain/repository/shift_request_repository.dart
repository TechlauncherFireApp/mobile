import 'package:fireapp/data/client/shift_request_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:injectable/injectable.dart';

import 'authentication_repository.dart';

@injectable
class ShiftRequestRepository {
  final ShiftRequestClient shiftRequestClient;
  final AuthenticationRepository _authenticationRepository;

  ShiftRequestRepository(this.shiftRequestClient, this._authenticationRepository);

  Future<List<ShiftRequest>> getShiftRequestsByRequestID(String requestID) {
    return shiftRequestClient.getShiftRequestsByRequestID(requestID);
  }

  Future<void> deleteShiftAssignment(int shiftId, int positionId) {
    return shiftRequestClient.deleteShiftAssignment(shiftId, positionId);
  }

  Future<void> updateShiftByPosition(int shiftId, int positionId, int volunteerId) {
    return shiftRequestClient.updateShiftByPosition(shiftId, positionId, volunteerId);
  }
}
