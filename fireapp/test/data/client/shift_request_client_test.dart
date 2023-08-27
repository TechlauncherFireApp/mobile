import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/shift_request_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<RestClient>(),
])
import 'shift_request_client_test.mocks.dart';

void main() {
  group('ShiftRequestClient', () {
    late RestClient mockRestClient;
    late ShiftRequestClient shiftRequestClient;

    setUp(() {
      mockRestClient = MockRestClient();
      shiftRequestClient = ShiftRequestClient(mockRestClient);
    });

    test('getShiftRequestsByRequestID should return a list of ShiftRequest from RestClient', () async {
      const requestID = 'ABC123';
      final expectedList = [
        ShiftRequest(
          shiftID: '1',
          assetClass: 'Asset A',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(hours: 1)),
          shiftVolunteers: [],
        ),
        // You can add more mock data to this list if necessary
      ];

      when(mockRestClient.getShiftRequest(requestID))
          .thenAnswer((_) async => expectedList);

      final result = await shiftRequestClient.getShiftRequestsByRequestID(requestID);

      expect(result, equals(expectedList));
      verify(mockRestClient.getShiftRequest(requestID)).called(1);
    });

    test('deleteShiftAssignment should call restClient.deleteShiftAssignment', () async {
      const shiftId = 1;
      const positionId = 2;
      final expectedResponse = {'message': 'Shift assignment deleted successfully'};

      when(mockRestClient.deleteShiftAssignment(shiftId, positionId))
          .thenAnswer((_) async => expectedResponse);

      final result = await shiftRequestClient.deleteShiftAssignment(shiftId, positionId);

      expect(result, equals(expectedResponse));
      verify(mockRestClient.deleteShiftAssignment(shiftId, positionId)).called(1);
    });

    test('updateShiftByPosition should call restClient.updateShiftByPosition', () async {
      const shiftId = 1;
      const positionId = 2;
      const volunteerId = 3;
      final expectedResponse = {'message': 'Shift updated successfully'};

      when(mockRestClient.updateShiftByPosition(shiftId, positionId, volunteerId))
          .thenAnswer((_) async => expectedResponse);

      final result = await shiftRequestClient.updateShiftByPosition(shiftId, positionId, volunteerId);

      expect(result, equals(expectedResponse));
      verify(mockRestClient.updateShiftByPosition(shiftId, positionId, volunteerId)).called(1);
    });

  });
}
