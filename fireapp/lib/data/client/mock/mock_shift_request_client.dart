import 'dart:convert';

import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:fireapp/environment_config.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../shift_request_client.dart';

@Injectable(as: ShiftRequestClient)
class ShiftRequestClientFacade implements ShiftRequestClient {

  final ConcreteShiftRequestClient _concreteShiftRequestClient;
  final MockShiftRequestClient _mockShiftRequestClient;
  ShiftRequestClientFacade(this._concreteShiftRequestClient, this._mockShiftRequestClient);

  @override
  Future<void> deleteShiftAssignment(int shiftId, int positionId) {
    if (EnvironmentConfig.mock) return _mockShiftRequestClient.deleteShiftAssignment(shiftId, positionId);
    return _concreteShiftRequestClient.deleteShiftAssignment(shiftId, positionId);
  }

  @override
  Future<List<ShiftRequest>> getShiftRequestsByRequestID(String requestID) {
    if (EnvironmentConfig.mock) return _mockShiftRequestClient.getShiftRequestsByRequestID(requestID);
    return _concreteShiftRequestClient.getShiftRequestsByRequestID(requestID);
  }

  @override
  Future<void> updateShiftByPosition(int shiftId, int positionId, int volunteerId) {
    if (EnvironmentConfig.mock) return _mockShiftRequestClient.updateShiftByPosition(shiftId, positionId, volunteerId);
    return _concreteShiftRequestClient.updateShiftByPosition(shiftId, positionId, volunteerId);
  }

}

@injectable
class MockShiftRequestClient implements ShiftRequestClient {
  Future<Map<String, dynamic>> _loadMockData() async {
    String jsonString = await rootBundle.loadString('assets/mock-data/shift_request.json');
    return json.decode(jsonString);
  }

  @override
  Future<List<ShiftRequest>> getShiftRequestsByRequestID(String requestID) async {
    Map<String, dynamic> mockData = await _loadMockData();
    return (mockData['results'] as List)
        .map((data) => ShiftRequest.fromJson(data))
        .toList();
  }

  @override
  Future<void> deleteShiftAssignment(int shiftId, int positionId) async {}

  @override
  Future<void> updateShiftByPosition(int shiftId, int positionId, int volunteerId) async {}

}