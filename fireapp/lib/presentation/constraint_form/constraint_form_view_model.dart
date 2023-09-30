import 'dart:async';
import 'package:fireapp/base/date_extensions.dart';
import 'package:fireapp/domain/models/new/vehicle_request.dart';
import 'package:fireapp/domain/models/scheduler/new_request.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/domain/repository/scheduler_constraint_form_repository.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_navigation.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/models/reference/asset_type.dart';
import '../../domain/request_state.dart';
import '../../global/di.dart';

@injectable
class SchedulerConstraintFormViewModel
    extends FireAppViewModel
    implements NavigationViewModel<ConstraintFormNavigation>
{
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

  List<AssetType> _assetTypesReal = [];
  final BehaviorSubject<RequestState<List<AssetType>>> _assetTypes =
      BehaviorSubject<RequestState<List<AssetType>>>();
  Stream<RequestState<List<AssetType>>> get assetsStream => _assetTypes.stream;
  AssetType? selectedAsset;

  final BehaviorSubject<RequestState<void>> _submissionState
    = BehaviorSubject.seeded(RequestState.success(null));
  Stream<RequestState<void>> get submissionState => _submissionState.stream;

  final BehaviorSubject<ConstraintFormNavigation> _navigate = BehaviorSubject();
  @override
  Stream<ConstraintFormNavigation> get navigate => _navigate.stream;

  SchedulerConstraintFormViewModel(this._referenceDataRepository, this._schedulerConstraintFormRepository) {
    fetchAssetTypes();
  }

  // Function to be called when the form is submitted
  void submitForm() {
    _submissionState.add(RequestState.loading());
    () async {
      try {
        var request = await _schedulerConstraintFormRepository.makeNewRequest(NewRequest(
          title: titleController.text,
          status:"",
        ));
        await _schedulerConstraintFormRepository.makeVehicleRequest(VehicleRequest(
            requestId: request.id,
            startDate: _selectedDate.value!.withTime(_selectedStartTime.value!),
            endDate: _selectedDate.value!.withTime(_selectedEndTime.value!),
            assetType: selectedAsset!.code
        ));
        _submissionState.add(RequestState.success(null));
        _navigate.add(ConstraintFormNavigation.shiftRequest(request.id));
      } catch(e) {
        _submissionState.add(RequestState.exception(e));
      }
    }();
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
  void fetchAssetTypes() {
    _assetTypes.add(RequestState.loading());
    () async {
      try {
        var assetTypes = await _referenceDataRepository.getAssetType();
        if (assetTypes.isEmpty) {
          assetTypes = [];
        }
        _assetTypesReal = assetTypes;
        _assetTypes.add(RequestState.success(assetTypes));
      } catch (e) {
        // Handle errors here
        print('Error fetching asset types: $e');
        _assetTypes.add(RequestState.exception(e));
      }
    }();
  }
}

