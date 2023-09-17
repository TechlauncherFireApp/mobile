import 'dart:convert';
import 'package:flutter/services.dart';

class MockDataService {
  Future<Map<String, dynamic>> loadShiftRequestMockData() async {
    String jsonString = await rootBundle.loadString('assets/mock-data/shift_request.json');
    return json.decode(jsonString);
  }
}