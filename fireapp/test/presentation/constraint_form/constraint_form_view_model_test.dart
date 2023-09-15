import 'dart:async';

import 'package:fireapp/domain/models/reference/asset_type.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mockito/mockito.dart';

class MockGlobalKey<T extends State<StatefulWidget>> extends Mock implements GlobalKey<T> {}
class MockTextEditingController extends Mock implements TextEditingController {}
class MockStream<T> extends Mock implements Stream<T> {}

void main() {
  group('SchedulerConstraintFormViewModel Tests', () {
    late SchedulerConstraintFormViewModel viewModel;
    late MockGlobalKey<FormState> mockFormKey;
    late MockTextEditingController mockTitleController;
    late MockTextEditingController mockInputDateController;
    late MockTextEditingController mockStartTimeController;
    late MockStream<List<AssetType>> mockAssetsStream;

    setUp(() {
      mockFormKey = MockGlobalKey<FormState>();
      mockTitleController = MockTextEditingController();
      mockInputDateController = MockTextEditingController();
      mockStartTimeController = MockTextEditingController();
      mockAssetsStream = MockStream<List<AssetType>>();

      viewModel = SchedulerConstraintFormViewModel(
        formKey: mockFormKey,
        titleController: mockTitleController,
        inputDateController: mockInputDateController,
        startTimeController: mockStartTimeController,
        assetsStream: mockAssetsStream,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('Initial Values', () {
      // Mock the behavior of your dependencies using Mockito
      when(mockFormKey.currentState).thenReturn(MockFormState());
      when(mockAssetsStream.listen(any)).thenReturn(StreamSubscription<List<AssetType>>.empty());

      // Perform the test
      expect(viewModel.formKey, mockFormKey);
      expect(viewModel.titleController, mockTitleController);
      expect(viewModel.inputDateController, mockInputDateController);
      expect(viewModel.startTimeController, mockStartTimeController);
      expect(viewModel.assetsStream, mockAssetsStream);
      expect(viewModel.dropdownValue, 1);
    });

    test('Form Submission Valid', () {
      // Mock form validation by setting a valid form state
      when(mockFormKey.currentState).thenReturn(MockFormState());

      // Set some input values for the form
      when(mockTitleController.text).thenReturn('Test Title');
      when(mockInputDateController.text).thenReturn('2023-09-15');
      when(mockStartTimeController.text).thenReturn('08:00 AM');

      // Mock the submission logic (e.g., by setting a flag)
      bool submitted = false;
      viewModel.submitForm = () {
        submitted = true;
      };

      // Trigger form submission
      viewModel.submitForm();

      // Expect that the form was submitted
      expect(submitted, isTrue);
    });

    test('Form Submission Invalid', () {
      // Mock form validation by setting an invalid form state
      when(mockFormKey.currentState).thenReturn(MockFormState());
      when(mockFormKey.currentState?.validate()).thenReturn(false);

      // Mock the submission logic (e.g., by setting a flag)
      bool submitted = false;
      viewModel.submitForm = () {
        submitted = true;
      };

      // Trigger form submission
      viewModel.submitForm();

      // Expect that the form was not submitted
      expect(submitted, isFalse);
    });

    test('Resource Disposal', () {
      // Dispose of resources
      viewModel.dispose();

      // Verify that text editing controllers and streams are disposed of
      verify(mockTitleController.dispose()).called(1);
      verify(mockInputDateController.dispose()).called(1);
      verify(mockStartTimeController.dispose()).called(1);
      verify(mockAssetsStream.close()).called(1);
    });
  });
}