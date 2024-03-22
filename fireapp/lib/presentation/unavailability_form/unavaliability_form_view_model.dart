import 'dart:async';

import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_navigation.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/request_state.dart';

@injectable
class UnavailabilityFormViewModel
    extends FireAppViewModel
    implements NavigationViewModel<ConstraintFormNavigation> {

  late final ReferenceDataRepository _referenceDataRepository;

  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController titleController = TextEditingController();

  final BehaviorSubject<DateTime?> _selectedStartDate = BehaviorSubject();
  Stream<DateTime?> get selectedStartDate => _selectedStartDate.stream;

  final BehaviorSubject<TimeOfDay?> _selectedStartTime = BehaviorSubject();
  Stream<TimeOfDay?> get selectedStartTime => _selectedStartTime.stream;

  final BehaviorSubject<DateTime?> _selectedEndDate = BehaviorSubject();
  Stream<DateTime?> get selectedEndDate => _selectedEndDate.stream;

  final BehaviorSubject<TimeOfDay?> _selectedEndTime = BehaviorSubject();
  Stream<TimeOfDay?> get selectedEndTime => _selectedEndTime.stream;


  final BehaviorSubject<RequestState<void>> _submissionState
  = BehaviorSubject.seeded(RequestState.success(null));

  Stream<RequestState<void>> get submissionState => _submissionState.stream;

  final BehaviorSubject<ConstraintFormNavigation> _navigate = BehaviorSubject();

  @override
  Stream<ConstraintFormNavigation> get navigate => _navigate.stream;

  // Function to be called when the form is submitted
  // void submitForm() {
  //   _submissionState.add(RequestState.loading());
  //   () async {
  //     try {
  //       var request = await _schedulerConstraintFormRepository.makeNewRequest(
  //           NewRequest(
  //             title: titleController.text,
  //             status: "",
  //           ));
  //       await _schedulerConstraintFormRepository.makeVehicleRequest(
  //           VehicleRequest(
  //               requestId: request.id,
  //               startDate: _selectedDate.value!.withTime(
  //                   _selectedStartTime.value!),
  //               endDate: _selectedDate.value!.withTime(_selectedEndTime.value!),
  //               assetType: selectedAsset!.code
  //           ));
  //       _submissionState.add(RequestState.success(null));
  //       _navigate.add(ConstraintFormNavigation.shiftRequest(request.id));
  //     } catch (e, stacktrace) {
  //       print(stacktrace);
  //       logger.e(e, stackTrace: stacktrace);
  //       _submissionState.add(RequestState.exception(e));
  //     }
  //   }
  //   ();
  // }

  void updateStartDate(DateTime? date) {
    _selectedStartDate.add(date);
  }

  void updateEndDate(DateTime? date) {
    _selectedEndDate.add(date);
  }

  void updateStartTime(TimeOfDay? time) {
    _selectedStartTime.add(time);
  }

  void updateEndTime(TimeOfDay? time) {
    _selectedEndTime.add(time);
  }

  void updateEventTitle(String? value){
    titleController.text = value ?? "";
  }

  @override
  Future<void> dispose() async {
    titleController.dispose();
    _selectedStartDate.close();
    _selectedStartTime.close();
    _selectedEndTime.close();
  }

}

