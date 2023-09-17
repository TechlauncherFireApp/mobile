import 'dart:convert';

import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShiftRequestClient {
  final RestClient restClient;
  ShiftRequestClient(this.restClient);

  Future<Map<String, dynamic>> _loadMockData() async {
    String jsonString = await rootBundle.loadString('assets/mock-data/shift_request.json');
    return json.decode(jsonString);
  }

  Future<List<ShiftRequest>> getShiftRequestsByRequestID(String requestID) async {
    Map<String, dynamic> mockData = await _loadMockData();
    List<ShiftRequest> shiftRequests = (mockData['results'] as List)
        .map((data) => ShiftRequest.fromJson(data))
        .toList();
    return shiftRequests;
  }

  Future<void> deleteShiftAssignment(int shiftId, int positionId) {
    return restClient.deleteShiftAssignment(shiftId, positionId);
  }

  Future<void> updateShiftByPosition(int shiftId, int positionId, int volunteerId) {
    return restClient.updateShiftByPosition(shiftId, positionId, volunteerId);
  }
}

