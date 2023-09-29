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
  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final SchedulerConstraintFormRepository
      _schedulerConstraintFormRepository;
  late final ReferenceDataRepository _referenceDataRepository;

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
    final newAsset = AssetType(
      id: 1, // Set the desired ID
      name: name, // Set the desired name
      code: name, // Set the desired code
      updated: DateTime.now(), // Set the desired updated date
      created: DateTime.now(), // Set the desired created date
    );

    if (_assetTypes.hasValue) {
      List<AssetType> currentAssetTypes = _assetTypes.value!; // Use ! to assert that it's not null

      // Step 2: Append the newAsset to the current list
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
  SchedulerConstraintFormViewModel() {
    // Initialize the ViewModel by fetching asset types
    fetchAssetTypes();
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

