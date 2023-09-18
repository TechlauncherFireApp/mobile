import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/shift_request_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([])
import 'concrete_shift_request_client_test.mocks.dart';

@GenerateMocks([RestClient])
void main() {
  group('ShiftRequestClient', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    late MockRestClient mockRestClient;
    late ShiftRequestClient shiftRequestClient;

    setUp(() {
      mockRestClient = MockRestClient();
      shiftRequestClient = ConcreteShiftRequestClient(mockRestClient);
    });

    test('getShiftRequestsByRequestID with MOCK_DATA should return mock data', () async {
      final expectedList = [
      ShiftRequest(
        shiftID: 'S001',
        assetClass: 'Vehicle',
        startTime: DateTime.parse("2023-08-19T14:00:00Z"),
        endTime: DateTime.parse("2023-08-19T18:00:00Z"),
        shiftVolunteers: [
          ShiftVolunteer(
            volunteerId: 1,
            volunteerGivenName: 'John',
            volunteerSurname: 'Doe',
            mobileNumber: '1234567890',
            positionId: 101,
            role: 'Driver',
            status: 'Active',
          ),
          ShiftVolunteer(
            volunteerId: 2,
            volunteerGivenName: 'Jane',
            volunteerSurname: 'Doe',
            mobileNumber: '0987654321',
            positionId: 102,
            role: 'Assistant',
            status: 'Active',
          ),
        ],
      ),
        ShiftRequest(
        shiftID: 'S002',
        assetClass: 'Equipment',
        startTime: DateTime.parse("2023-08-20T09:00:00Z"),
        endTime: DateTime.parse("2023-08-20T15:00:00.000Z"),
        shiftVolunteers: [
          ShiftVolunteer(
            volunteerId: 3,
            volunteerGivenName: 'Alice',
            volunteerSurname: 'Smith',
            mobileNumber: '1122334455',
            positionId: 103,
            role: 'Operator',
            status: 'Active',
          ),
        ],
      ),
    ];

      final result = await shiftRequestClient.getShiftRequestsByRequestID("MOCK_DATA");

      expect(result, equals(expectedList));
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
