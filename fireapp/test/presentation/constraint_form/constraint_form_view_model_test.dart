import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:fireapp/domain/repository/scheduler_constraint_form_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/expect.dart';

// Import necessary test harness
import 'package:mockito/mockito.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';

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
    flutter_test.test('selectDate should set the selected date', () {
      // Arrange
      final date = DateTime(2023, 9, 22);

      // Act
      viewModel.selectDate(date);

      // Assert
      expect(viewModel.selectedDate, emits(date));
    });

    flutter_test.test('selectStartTime should set the selected start time', () {
      // Arrange
      const time = TimeOfDay(hour: 9, minute: 30);

      // Act
      viewModel.selectStartTime(time);

      // Assert
      expect(viewModel.selectedStartTime, emits(time));
    });

    flutter_test.test('selectEndTime should set the selected end time', () {
      // Arrange
      const time = TimeOfDay(hour: 11, minute: 45);

      // Act
      viewModel.selectEndTime(time);

      // Assert
      expect(viewModel.selectedEndTime, emits(time));
    });

    flutter_test.test('Dispose method should close BehaviorSubjects', () {
      // Call the dispose method
      viewModel.dispose();
    });
  });
}
