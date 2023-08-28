import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/shift_request_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:mockito/annotations.dart';

import 'authentication_client_test.mocks.dart';

@GenerateMocks([RestClient])
void main() {
  group('ShiftRequestClient', () {
    late RestClient mockRestClient;
    late ShiftRequestClient shiftRequestClient;

    setUp(() {
      mockRestClient = MockRestClient();
      shiftRequestClient = ShiftRequestClient(mockRestClient);
    });

    test('getShiftRequestsByRequestID should return a list of ShiftRequest', () async {
      const requestID = 'ABC123';
      final expectedList = [
        ShiftRequest(
          shiftID: '123',
          assetClass: 'A1',
          startTime: DateTime(2023, 1, 1, 10, 0),
          endTime: DateTime(2023, 1, 1, 12, 0),
          shiftVolunteers: [
            ShiftVolunteer(
              volunteerId: 1,
              volunteerGivenName: 'John',
              volunteerSurname: 'Doe',
              mobileNumber: '1234567890',
              positionId: 1,
              role: 'RoleA',
              status: 'Active',
            ),
          ],
        ),
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

      when(mockRestClient.deleteShiftAssignment(shiftId, positionId))
          .thenAnswer((_) async => null);

      await shiftRequestClient.deleteShiftAssignment(shiftId, positionId);

      verify(mockRestClient.deleteShiftAssignment(shiftId, positionId)).called(1);
    });

    test('updateShiftByPosition should call restClient.updateShiftByPosition', () async {
      const shiftId = 1;
      const positionId = 2;
      const volunteerId = 3;

      when(mockRestClient.updateShiftByPosition(shiftId, positionId, volunteerId))
          .thenAnswer((_) async => null);

      await shiftRequestClient.updateShiftByPosition(shiftId, positionId, volunteerId);

      verify(mockRestClient.updateShiftByPosition(shiftId, positionId, volunteerId)).called(1);
    });
  });
}
