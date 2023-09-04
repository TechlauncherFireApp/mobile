import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/request_state.dart';

class SchedulerConstraintFormViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController inputDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  // RequestState stream
  final BehaviorSubject<RequestState<void>> _state = BehaviorSubject.seeded(RequestState.initial());
  Stream<RequestState<void>> get state => _state.stream;

  // Dummy values for the assets list
  final Stream<List<int>> assetsStream = Stream<List<int>>.value([1, 2, 3, 4]);

  // Current dropdown value
  int dropdownValue = 1;

  // Function to be called when the form is submitted
  void submitForm() {
    if (formKey.currentState?.validate() == true) {
      // add submission logic here
    } else {
      // If the form is not valid, handle accordingly
    }
  }


  void dispose() { // Dispose of resources
    titleController.dispose();
    inputDateController.dispose();
    startTimeController.dispose();
    _state.close();
  }
}
