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

  final BehaviorSubject<DateTime?> _selectedDate = BehaviorSubject();
  Stream<DateTime?> get selectedDate => _selectedDate.stream;

  final BehaviorSubject<TimeOfDay?> _selectedStartTime = BehaviorSubject();
  Stream<TimeOfDay?> get selectedStartTime => _selectedStartTime.stream;

  final BehaviorSubject<TimeOfDay?> _selectedEndTime = BehaviorSubject();
  Stream<TimeOfDay?> get selectedEndTime => _selectedStartTime.stream;

  final BehaviorSubject<List<AssetType>> _assetTypes =
      BehaviorSubject<List<AssetType>>();
  Stream<List<AssetType>> get assetsStream => _assetTypes.stream;

  // Current dropdown value
  int? dropdownValue;

  // Function to be called when the form is submitted
  void submitForm() {
    final String name = titleController.text;

    // if (_assetTypes.value.isEmpty || name.isEmpty || date.isEmpty || time.isEmpty) {
    //   // Handle validation or show an error message.
    //   const errorMessage = "Please provide all required data";
    //   _assetTypes.add(RequestState.exception(errorMessage) as List<AssetType>);
    //   return;
    // }
    //
    // try {
    //   // Assuming you have a method to submit this data to the repository
    //   _schedulerConstraintFormRepository.getAssetType(
    //     _assetTypes.value[0].id,
    //     _assetTypes.value[2].code,
    //     name,
    //     date as DateTime,
    //     time as DateTime,
    //   );
    //   _assetTypes.add(RequestState.success(null) as List<AssetType>);
    // } catch (e) {
    //   logger.e(e);
    //   _assetTypes.add(RequestState.exception(e) as List<AssetType>);
    // }
  }

  void selectDate(DateTime? date) {
    _selectedDate.value = date;
  }

  void selectStartTime(TimeOfDay? time) {
    _selectedStartTime.value = time;
  }

  void selectEndTime(TimeOfDay? time) {
    _selectedEndTime.value = time;
  }

  @override
  Future<void> dispose() async {
    titleController.dispose();
    _selectedDate.close();
    _selectedStartTime.close();
    _selectedEndTime.close();
    _assetTypes.close();
  }
}
