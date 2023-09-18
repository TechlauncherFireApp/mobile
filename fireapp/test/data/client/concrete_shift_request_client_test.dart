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
