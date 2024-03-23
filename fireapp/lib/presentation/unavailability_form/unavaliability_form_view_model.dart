import 'dart:async';

import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_navigation.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/request_state.dart';
import '../../global/di.dart';
import 'package:fireapp/domain/repository/unavailability_form_repository.dart';

@injectable
class UnavailabilityFormViewModel
    extends FireAppViewModel
    implements NavigationViewModel<ConstraintFormNavigation> {

  late final ReferenceDataRepository _referenceDataRepository;
  late final UnavailabilityFormRepository
  _unavailabilityFormRepository;

  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //TODO load in event ID and existing information
  final eventId = null;

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

  void submitForm() {
    _submissionState.add(RequestState.loading());
      () async {
        try {
          //Combine start date and start time
          DateTime startDateTime = DateTime(_selectedStartDate.value!.year,
              _selectedStartDate.value!.month, _selectedStartDate.value!.day,
              _selectedStartTime.value!.hour, _selectedStartTime.value!.minute);
          //Combine end date and end time
          DateTime endDateTime = DateTime(_selectedEndDate.value!.year,
              _selectedEndDate.value!.month, _selectedEndDate.value!.day,
              _selectedEndTime.value!.hour, _selectedEndTime.value!.minute);

              //   periodicity: 0,
              //         start: _selectedStartDate.value,
              //         end: _selectedEndDate.value)
          // var request = await _schedulerConstraintFormRepository.makeNewRequest(NewRequest(
          //   title: titleController.text,
          //   status:"",
          // ));
          // await
          // // _dietaryRequirementsRepository.updateDietaryRequirements(
          //     const UnavailabilityTime(
          //   eventId: null,
          //   userId: null,
          //   title: titleController.text,
          //   periodicity: 0,
          //         start: _selectedStartDate.value,
          //         end: _selectedEndDate.value
          //
          //     );
          // );
          _submissionState.add(RequestState.success(null));

        }
        catch (e, stacktrace) {
          print(stacktrace);
          logger.e(e, stackTrace: stacktrace);
          _submissionState.add(RequestState.exception(e));
        }
      }
      ();
  }

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
    _selectedEndDate.close();
    _selectedEndTime.close();
  }

}

