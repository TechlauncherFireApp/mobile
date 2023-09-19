import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:fireapp/domain/models/reference/asset_type.dart';

void main() {
  group('SchedulerConstraintFormViewModel', () {
    test('submitForm - valid form', () {
      final viewModel = SchedulerConstraintFormViewModel();

      // Create a GlobalKey<FormState>
      final formKey = GlobalKey<FormState>();

      // Set up the form with valid data
      viewModel.titleController.text = 'Valid Title';
      viewModel.inputDateController.text = '2023-09-19'; // Valid date format
      viewModel.startTimeController.text = '12:00 PM'; // Valid time format

      // Call the submitForm method with the formKey
      viewModel.submitForm(formKey);

      // Verify that the submission logic is called as expected or add your verification logic here
      // For example, you can expect that the submission logic updates some state.
    });

    test('submitForm - invalid form', () {
      final viewModel = SchedulerConstraintFormViewModel();

      // Create a GlobalKey<FormState>
      final formKey = GlobalKey<FormState>();

      // Set up the form with invalid data
      viewModel.titleController.text = ''; // Empty title (invalid)
      viewModel.inputDateController.text = 'invalid_date'; // Invalid date format
      viewModel.startTimeController.text = 'invalid_time'; // Invalid time format

      // Call the submitForm method with the formKey
      viewModel.submitForm(formKey);

      // Verify that the submission logic is not called or add your verification logic here
      // For example, you can expect that the submission logic is not called when the form is invalid.
    });

    // Add more test cases as needed to cover other methods and scenarios
  });
}
