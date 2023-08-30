import 'dart:async';
import 'package:flutter/material.dart';

class ConstraintFormViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController inputDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  // Dummy values for the assets list
  final Stream<List<int>> assetsStream = Stream<List<int>>.value([1, 2, 3, 4]);

  // Current dropdown value
  int dropdownValue = 1;

  // Function to be called when the form is submitted
  void submitForm() {
    formKey.currentState!.validate();
      // sending the data to database or other page
}

  void dispose() {
    titleController.dispose();
    inputDateController.dispose();
    startTimeController.dispose();
  }
}