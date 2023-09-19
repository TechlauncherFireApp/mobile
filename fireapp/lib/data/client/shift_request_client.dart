import 'dart:convert';

import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:fireapp/environment_config.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

abstract class ShiftRequestClient {
  Future<List<ShiftRequest>> getShiftRequestsByRequestID(String requestID);
  Future<void> deleteShiftAssignment(int shiftId, int positionId);
  Future<void> updateShiftByPosition(int shiftId, int positionId, int volunteerId);
}

@injectable
class ConcreteShiftRequestClient implements ShiftRequestClient {
  final RestClient restClient;
  ConcreteShiftRequestClient(this.restClient);

  @override
  Future<List<ShiftRequest>> getShiftRequestsByRequestID(String requestID) async {
    return restClient.getShiftRequest(requestID);
  }

  @override
  Future<void> deleteShiftAssignment(int shiftId, int positionId) {
    return restClient.deleteShiftAssignment(shiftId, positionId);
  }

  @override
  Future<void> updateShiftByPosition(int shiftId, int positionId, int volunteerId) {
    return restClient.updateShiftByPosition(shiftId, positionId, volunteerId);
  }
}
