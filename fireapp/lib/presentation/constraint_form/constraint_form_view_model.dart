import 'dart:async';
import 'package:fireapp/domain/repository/scheduler_constraint_form_repository.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/models/reference/asset_type.dart';
import '../../domain/request_state.dart';
import '../../global/di.dart';

@injectable
class SchedulerConstraintFormViewModel extends FireAppViewModel {
  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final SchedulerConstraintFormRepository
      _schedulerConstraintFormRepository;

  // Text Editing Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController inputDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();


  final BehaviorSubject<List<AssetType>> _assetTypes =
      BehaviorSubject<List<AssetType>>();
  Stream<List<AssetType>> get assetsStream => _assetTypes.stream;

  // Current dropdown value
  int dropdownValue = 1;

  // Function to be called when the form is submitted
  void submitForm() {
    final String name = titleController.text;
    final String date = inputDateController.text;
    final String time = startTimeController.text;

    if (_assetTypes.value.isEmpty || name.isEmpty || date.isEmpty || time.isEmpty) {
      // Handle validation or show an error message.
      const errorMessage = "Please provide all required data";
      _assetTypes.add(RequestState.exception(errorMessage) as List<AssetType>);
      return;
    }

    try {
      // Assuming you have a method to submit this data to the repository
      _schedulerConstraintFormRepository.getAssetType(
        _assetTypes.value[0].id,
        _assetTypes.value[2].code,
        name,
        date as DateTime,
        time as DateTime,
      );
      _assetTypes.add(RequestState.success(null) as List<AssetType>);
    } catch (e) {
      logger.e(e);
      _assetTypes.add(RequestState.exception(e) as List<AssetType>);
    }
  }

  @override
  Future<void> dispose() async {
    titleController.dispose();
    inputDateController.dispose();
    startTimeController.dispose();
    _assetTypes.close();
  }
}
