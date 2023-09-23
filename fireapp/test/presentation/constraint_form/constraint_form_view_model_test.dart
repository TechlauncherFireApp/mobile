import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:fireapp/domain/repository/scheduler_constraint_form_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/expect.dart';

@GenerateNiceMocks([
  MockSpec<SchedulerConstraintFormRepository>(),
])
import 'constraint_form_view_model_test.mocks.dart';

void main() {
  late SchedulerConstraintFormViewModel viewModel;
  late MockSchedulerConstraintFormRepository mockRepository;

  flutter_test.setUp(() {
    mockRepository = MockSchedulerConstraintFormRepository();
    viewModel = SchedulerConstraintFormViewModel();
  });

  flutter_test.group('SchedulerConstraintFormViewModel', () {
    flutter_test.test('Submit Form with Valid Data', () {
      // Prepare test data
      final assetType = AssetType(
        id: 1,
        name: 'Asset 1',
        code: 'A1',
        updated: DateTime.now(),
        created: DateTime.now(),
      );

      // Set the form values
      viewModel.titleController.text = 'Test Title';
      viewModel.selectDate(DateTime.now());
      viewModel.selectStartTime(TimeOfDay.now());

      // Mock the repository method to return the test data
      when(mockRepository.getAssetType(any, any, any, any, any))
          .thenAnswer((_) async => [assetType]);

      // Trigger the form submission
      viewModel.submitForm();

      // Verify that the repository method was called with the expected values
      verify(mockRepository.getAssetType(
        any,
        'Test Title',
        any,
        any,
        any,
      )).called(1);

      // Expect that the assetTypes stream emits the success state
      expectLater(
        viewModel.assetsStream,
        emitsInOrder([
          [],
          [assetType],
        ]),
      );
    });

    flutter_test.test('Submit Form with Empty Data', () {
      // Set the form values to empty
      viewModel.titleController.text = '';
      viewModel.selectDate(null);
      viewModel.selectStartTime(null);

      // Trigger the form submission
      viewModel.submitForm();

      // Expect that the assetTypes stream emits an exception state
      expectLater(
        viewModel.assetsStream,
        emitsInOrder([
          [],
          emits(const TypeMatcher<ExceptionRequestState<List<AssetType>>>()),
        ]),
      );
    });

    flutter_test.test('Dispose method should close BehaviorSubjects', () {
      // Call the dispose method
      viewModel.dispose();
    });
  });
}
