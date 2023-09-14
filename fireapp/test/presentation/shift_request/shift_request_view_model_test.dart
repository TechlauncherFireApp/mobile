import 'package:fireapp/domain/models/shift_request.dart';
import 'package:fireapp/domain/repository/shift_request_repository.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/shift_request/shift_request_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'shift_request_view_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ShiftRequestRepository>(),
])

void main() {
  group('ShiftRequestViewModel', () {
    late MockShiftRequestRepository shiftRequestRepository;
    late ShiftRequestViewModel viewModel;

    setUp(() {
      shiftRequestRepository = MockShiftRequestRepository();
      viewModel = ShiftRequestViewModel(shiftRequestRepository);
    });

    test('loads shift requests successfully', () async {
      final shiftRequests = [
        ShiftRequest(
          shiftID: "1",
          assetClass: "Class1",
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(hours: 1)),
          shiftVolunteers: [], // Add mock shift volunteers if needed
        ),
        // Add more mock shift requests if needed
      ];

      when(shiftRequestRepository.getShiftRequestsByRequestID(any))
          .thenAnswer((_) async => shiftRequests);

      viewModel.loadShiftRequests("mockRequestId");
      await Future.delayed(Duration(milliseconds: 100));

      final shiftRequestsState = viewModel.shiftRequests as BehaviorSubject<RequestState<List<ShiftRequest>>>;
      expect(shiftRequestsState.value, isA<SuccessRequestState<List<ShiftRequest>>>());
      expect((shiftRequestsState.value as SuccessRequestState).result, isNotEmpty);
    });

    test('deletes shift assignment successfully', () async {
      when(shiftRequestRepository.deleteShiftAssignment(any, any))
          .thenAnswer((_) async => null);

      viewModel.deleteShiftAssignment(1, 1);
      await Future.delayed(Duration(milliseconds: 100));

      final updateState = viewModel.updateState as BehaviorSubject<RequestState<void>>;
      expect(updateState.value, isA<SuccessRequestState<void>>());
    });

    test('updates shift by position successfully', () async {
      when(shiftRequestRepository.updateShiftByPosition(any, any, any))
          .thenAnswer((_) async => null);

      viewModel.updateShiftByPosition(1, 1, 1);
      await Future.delayed(Duration(milliseconds: 100));

      final updateState = viewModel.updateState as BehaviorSubject<RequestState<void>>;
      expect(updateState.value, isA<SuccessRequestState<void>>());
    });

  });
}
