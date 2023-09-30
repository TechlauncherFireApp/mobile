import 'dart:async';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
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
  late final SchedulerConstraintFormRepository
    _schedulerConstraintFormRepository;
  late final ReferenceDataRepository _referenceDataRepository;

  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  SchedulerConstraintFormViewModel(this._referenceDataRepository, this._schedulerConstraintFormRepository) {
    fetchAssetTypes();
  }

  // Function to be called when the form is submitted
  void submitForm() {
    final String name = titleController.text;
    final newAsset = AssetType(
      id: 1,
      name: name,
      code: name,
      updated: DateTime.now(),
      created: DateTime.now(),
    );

    if (_assetTypes.hasValue) {
      List<AssetType> currentAssetTypes = _assetTypes.value!;

       //Append the newAsset to the current list
      currentAssetTypes.add(newAsset);
      _assetTypes.add(currentAssetTypes);
    } else {
      _assetTypes.add([newAsset]);
    }

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

  // Create a method to fetch and update asset types
  Future<void> fetchAssetTypes() async {
    try {
      var assetTypes = await _referenceDataRepository.getAssetType();
      if (assetTypes.isEmpty) {
        assetTypes = [];
      }
      _assetTypes.add(assetTypes);
    } catch (e) {
      // Handle errors here
      print('Error fetching asset types: $e');
    }
  }
  }

