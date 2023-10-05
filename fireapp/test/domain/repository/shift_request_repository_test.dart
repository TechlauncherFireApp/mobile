import 'package:fireapp/data/client/shift_request_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:fireapp/domain/repository/shift_request_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:matcher/expect.dart' hide expectLater, expect;

@GenerateNiceMocks([
  MockSpec<ConcreteShiftRequestClient>(),
])
import 'shift_request_repository_test.mocks.dart'; // This should be auto-generated

void main() {
  group('ShiftRequestRepository', () {
    late ShiftRequestClient mockShiftRequestClient;
    late ShiftRequestRepository shiftRequestRepository;

    setUp(() {
      mockShiftRequestClient = MockConcreteShiftRequestClient();
      shiftRequestRepository = ShiftRequestRepository(mockShiftRequestClient);
    });

    test('getShiftRequestsByRequestID should return a list of ShiftRequest', () async {
      const requestID = 'ABC123';
      final expectedList = [
        ShiftRequest(
          shiftID: '1',
          assetClass: 'Asset A',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(hours: 1)),
          shiftVolunteers: [],
        ),
      ];

      when(mockShiftRequestClient.getShiftRequestsByRequestID(requestID))
          .thenAnswer((_) async => expectedList);

      final result = await shiftRequestRepository.getShiftRequestsByRequestID(requestID);

      expect(result, equals(expectedList));
      verify(mockShiftRequestClient.getShiftRequestsByRequestID(requestID)).called(1);
    });

    test('deleteShiftAssignment should call shiftRequestClient.deleteShiftAssignment', () async {
      const shiftId = 1;
      const positionId = 2;

      when(mockShiftRequestClient.deleteShiftAssignment(shiftId, positionId))
          .thenAnswer((_) async => null);

      await shiftRequestRepository.deleteShiftAssignment(shiftId, positionId);

      verify(mockShiftRequestClient.deleteShiftAssignment(shiftId, positionId)).called(1);
    });

    test('updateShiftByPosition should call shiftRequestClient.updateShiftByPosition', () async {
      const shiftId = 1;
      const positionId = 2;
      const volunteerId = 3;

      when(mockShiftRequestClient.updateShiftByPosition(shiftId, positionId, volunteerId))
          .thenAnswer((_) async => null);

      await shiftRequestRepository.updateShiftByPosition(shiftId, positionId, volunteerId);

      verify(mockShiftRequestClient.updateShiftByPosition(shiftId, positionId, volunteerId)).called(1);
    });
  });
}
