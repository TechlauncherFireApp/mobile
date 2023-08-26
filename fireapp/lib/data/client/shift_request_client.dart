import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShiftRequestClient {
  final RestClient restClient;
  ShiftRequestClient(this.restClient);

  Future<List<ShiftRequest>> getShiftRequestsByRequestID(String requestID) {
    return restClient.getShiftRequest(requestID);
  }

  Future<Map<String, dynamic>> deleteShiftAssignment(int shiftId, int positionId) {
    return restClient.deleteShiftAssignment(shiftId, positionId);
  }

  Future<Map<String, dynamic>> updateShiftByPosition(int shiftId, int positionId, int volunteerId) {
    return restClient.updateShiftByPosition(shiftId, positionId, volunteerId);
  }
}
