import 'dart:async';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/models/reference/asset_type.dart';

class SchedulerConstraintFormViewModel extends FireAppViewModel {
  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController inputDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  final BehaviorSubject<List<AssetType>> _assetTypes = BehaviorSubject<List<AssetType>>();
  Stream<List<AssetType>> get assetsStream => _assetTypes.stream;

  // Current dropdown value
  int dropdownValue = 1;

  // Function to be called when the form is submitted
  void submitForm() {
    if (formKey.currentState?.validate() != true) return;
    // Submission logic here
  }

  @override
  Future<void> dispose() async {
    titleController.dispose();
    inputDateController.dispose();
    startTimeController.dispose();
    _assetTypes.close();
  }
}