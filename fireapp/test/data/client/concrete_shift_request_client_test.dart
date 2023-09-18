import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fireapp/data/client/api/rest_client.dart';
import 'package:fireapp/data/client/shift_request_client.dart';
import 'package:fireapp/domain/models/shift_request.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<RestClient>()
])
import 'concrete_shift_request_client_test.mocks.dart';

void main() {
  group('ShiftRequestClient', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    late MockRestClient mockRestClient;
    late ShiftRequestClient shiftRequestClient;

    setUp(() {
      mockRestClient = MockRestClient();
      shiftRequestClient = ConcreteShiftRequestClient(mockRestClient);
    });

    test('deleteShiftAssignment should call restClient.deleteShiftAssignment', () async {
      const shiftId = 1;
      const positionId = 2;

      when(mockRestClient.deleteShiftAssignment(shiftId, positionId))
          .thenAnswer((_) async => null);

      await shiftRequestClient.deleteShiftAssignment(shiftId, positionId);

      verify(mockRestClient.deleteShiftAssignment(shiftId, positionId)).called(1);
    });

    test('getShiftRequestsByRequestID returns a list of ShiftRequest', () async {
      const fakeRequestID = 'fakeRequestID';
      final fakeShiftRequestList = [
        ShiftRequest(
          shiftID: "1",
          assetClass: "Class1",
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(hours: 1)),
          shiftVolunteers: [],
        ),
      ];

      // Create a mock RestClient (you'll need a mocking library for this)
      final mockRestClient = MockRestClient();

      // Set up the behavior of the mock RestClient
      when(mockRestClient.getShiftRequest(any))
          .thenAnswer((_) async => fakeShiftRequestList);

      final concreteShiftRequestClient = ConcreteShiftRequestClient(mockRestClient);

      // Act
      final result = await concreteShiftRequestClient.getShiftRequestsByRequestID(fakeRequestID);

      // Assert
      expect(result, equals(fakeShiftRequestList));
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
