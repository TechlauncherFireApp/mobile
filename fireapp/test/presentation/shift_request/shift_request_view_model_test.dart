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

@GenerateMocks([ShiftRequestRepository])
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
          shiftVolunteers: [],
        ),
      ];

      when(shiftRequestRepository.getShiftRequestsByRequestID(any))
          .thenAnswer((_) async => shiftRequests);

      final emittedStates = [];
      final subscription = viewModel.shiftRequests.listen(emittedStates.add);

      viewModel.loadShiftRequests("mockRequestId");
      await Future.delayed(Duration(milliseconds: 100));

      expect(emittedStates.last, isA<SuccessRequestState<List<ShiftRequest>>>());
      expect((emittedStates.last as SuccessRequestState<List<ShiftRequest>>).result, isNotEmpty);

      subscription.cancel();
    });

    test('deletes shift assignment successfully', () async {
      when(shiftRequestRepository.deleteShiftAssignment(any, any))
          .thenAnswer((_) async => null);

      final emittedStates = [];
      final subscription = viewModel.updateState.listen(emittedStates.add);

      viewModel.deleteShiftAssignment(1, 1);
      await Future.delayed(Duration(milliseconds: 100));

      expect(emittedStates.last, isA<SuccessRequestState<void>>());

      subscription.cancel();
    });

    test('updates shift by position successfully', () async {
      when(shiftRequestRepository.updateShiftByPosition(any, any, any))
          .thenAnswer((_) async => null);

      final emittedStates = [];
      final subscription = viewModel.updateState.listen(emittedStates.add);

      viewModel.updateShiftByPosition(1, 1, 1);
      await Future.delayed(Duration(milliseconds: 100));

      expect(emittedStates.last, isA<SuccessRequestState<void>>());

      subscription.cancel();
    });

    test('loads shift requests unsuccessfully', () async {
      // Arrange
      const requestId = 'test';
      const error = 'error';
      when(shiftRequestRepository.getShiftRequestsByRequestID(requestId)).thenThrow(error);

      // Assert
      expectLater(viewModel.shiftRequests, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<List<ShiftRequest>>>()),
        emits(const TypeMatcher<LoadingRequestState<List<ShiftRequest>>>()),
        emits(const TypeMatcher<ExceptionRequestState<List<ShiftRequest>>>())
      ]));

      // Act
      viewModel.loadShiftRequests(requestId);
    });

    test('deletes shift assignment unsuccessfully', () async {
      // Arrange
      const shiftId = 1;
      const positionId = 5; 
      const error = 'error';
      when(shiftRequestRepository.deleteShiftAssignment(shiftId, positionId)).thenThrow(error);

      // Assert
      expectLater(viewModel.updateState, emitsInOrder([
        emits(const TypeMatcher<SuccessRequestState<void>>()),
        emits(const TypeMatcher<ExceptionRequestState<void>>())
      ]));

      // Act
      viewModel.deleteShiftAssignment(shiftId, positionId);
    });

    test('updates shift by position unsuccessfully', () async {
      // Arrange
      const shiftId = 1;
      const positionId = 5;
      const volunteerId = 5;
      const error = 'error';
      when(shiftRequestRepository.updateShiftByPosition(shiftId, positionId, volunteerId)).thenThrow(error);

      // Assert
      expectLater(viewModel.updateState, emitsInOrder([
        emits(const TypeMatcher<SuccessRequestState<void>>()),
        emits(const TypeMatcher<ExceptionRequestState<void>>())
      ]));

      // Act
      viewModel.updateShiftByPosition(shiftId, positionId, volunteerId);
    });

    test('dispose throws nothing', () {
      viewModel.dispose();
    });
  });
}
