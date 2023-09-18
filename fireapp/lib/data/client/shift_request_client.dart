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
    if (requestID == "MOCK_DATA") { // You can decide the condition here
      Map<String, dynamic> mockData = await _loadMockData();
      return (mockData['results'] as List)
          .map((data) => ShiftRequest.fromJson(data))
          .toList();
    } else {
      // Make the actual API call using the restClient
      // For now, I'm returning an empty list as a placeholder
      return [];
    }
  }

  Future<void> deleteShiftAssignment(int shiftId, int positionId) {
    return restClient.deleteShiftAssignment(shiftId, positionId);
  }

  Future<void> updateShiftByPosition(int shiftId, int positionId, int volunteerId) {
    return restClient.updateShiftByPosition(shiftId, positionId, volunteerId);
  }
}

