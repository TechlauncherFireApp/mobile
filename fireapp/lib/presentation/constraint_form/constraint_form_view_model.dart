import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/models/reference/asset_type.dart';
class SchedulerConstraintFormViewModel {
  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController inputDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  final BehaviorSubject<List<AssetType>> _assetTypes = BehaviorSubject<List<AssetType>>();
  Stream<List<AssetType>> get assetsStream => _assetTypes.stream;

  // Current dropdown value
  int dropdownValue = 1;

  set submitFormCallback(Null Function() submitFormCallback) {}

  // Function to be called when the form is submitted
  void submitForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() != true) return;
    // Submission logic here
  }

  void dispose() { // Dispose of resources
    titleController.dispose();
    inputDateController.dispose();
    startTimeController.dispose();
    _assetTypes.close();
  }
}