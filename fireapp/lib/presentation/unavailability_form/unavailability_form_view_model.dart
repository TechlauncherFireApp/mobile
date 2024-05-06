import 'dart:async';

import 'package:fireapp/domain/models/unavailability/unavailability_event_post.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/presentation/unavailability_form/unavailability_form_navigation.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/request_state.dart';
import '../../global/di.dart';
import 'package:fireapp/domain/repository/unavailability_repository.dart';

@injectable
class UnavailabilityFormViewModel extends FireAppViewModel
    implements NavigationViewModel<UnavailabilityFormNavigation> {
  //Load in authentication and unavailability actions
  late final AuthenticationRepository _authenticationRepository;
  late final UnavailabilityRepository _unavailabilityRepository;

  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var eventID;
  // Editing Controllers
  final TextEditingController titleController = TextEditingController();

  //final _selectedStartDate = StreamController<DateTime?>.broadcast();
  final BehaviorSubject<DateTime?> _selectedStartDate = BehaviorSubject();
  Stream<DateTime?> get selectedStartDate => _selectedStartDate.stream;

  final BehaviorSubject<TimeOfDay?> _selectedStartTime = BehaviorSubject();
  Stream<TimeOfDay?> get selectedStartTime => _selectedStartTime.stream;

  final BehaviorSubject<DateTime?> _selectedEndDate = BehaviorSubject();
  Stream<DateTime?> get selectedEndDate => _selectedEndDate.stream;

  final BehaviorSubject<TimeOfDay?> _selectedEndTime = BehaviorSubject();
  Stream<TimeOfDay?> get selectedEndTime => _selectedEndTime.stream;

  // Loading State controllers
  final BehaviorSubject<RequestState<void>> _submissionState =
      BehaviorSubject.seeded(RequestState.success(null));
  Stream<RequestState<void>> get submissionState => _submissionState.stream;

  // Track if form is filled
  final BehaviorSubject<bool> _isFormValid = BehaviorSubject.seeded(false);
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  // Determine if in edit mode
  bool isEditMode = false;

// Method to check form validity (if form has all fields filled)
  void checkFormValidity() {
    bool isFormValid = titleController.text.isNotEmpty &&
        _selectedStartDate.hasValue &&
        _selectedStartTime.hasValue &&
        _selectedEndDate.hasValue &&
        _selectedEndTime.hasValue;
    _isFormValid.add(isFormValid);
  }

  // Navigation handling
  final BehaviorSubject<UnavailabilityFormNavigation> _navigate =
      BehaviorSubject();

  @override
  Stream<UnavailabilityFormNavigation> get navigate => _navigate.stream;

  UnavailabilityFormViewModel(
      this._authenticationRepository, this._unavailabilityRepository);

  loadForm(UnavailabilityTime event) async {
    isEditMode = event.eventId >= 0;
    if (isEditMode) {
      eventID = event.eventId;
      updateEventTitle(event.title);
      updateStartDate(event.startTime);
      updateEndDate(event.endTime);
      final startTime =
          TimeOfDay(hour: event.startTime.hour, minute: event.startTime.minute);
      final endTime =
          TimeOfDay(hour: event.endTime.hour, minute: event.endTime.minute);
      updateStartTime(startTime);
      updateEndTime(endTime);
    }
  }

  void submitForm() {
    _submissionState.add(RequestState.loading());
    () async {
      try {
        var userID =
            (await _authenticationRepository.getCurrentSession())?.userId;

        // Check if userId is null and throw an exception if it is
        if (userID == null) {
          throw Exception(
              'User ID is null. Cannot update roles without a valid user ID.');
        }

        const int periodicity = 0;

        //Combine start date and start time
        DateTime startDateTime = DateTime(
            _selectedStartDate.value!.year,
            _selectedStartDate.value!.month,
            _selectedStartDate.value!.day,
            _selectedStartTime.value!.hour,
            _selectedStartTime.value!.minute);
        // Combine end date and end time
        DateTime endDateTime = DateTime(
            _selectedEndDate.value!.year,
            _selectedEndDate.value!.month,
            _selectedEndDate.value!.day,
            _selectedEndTime.value!.hour,
            _selectedEndTime.value!.minute);

        // Check if startDateTime is before endDateTime
        if (!startDateTime.isBefore(endDateTime)) {
          throw Exception('The start time must be before the end time.');
        }

        var event = UnavailabilityEventPost(
            title: titleController.text,
            start: startDateTime,
            end: endDateTime,
            periodicity: periodicity);

        if (isEditMode) {
          print("EDITING");
          await _unavailabilityRepository.editUnavailabilityEvent(
              userID, eventID, event);
        } else {
          // Submit and navigate back to Calendar if successful.
          await _unavailabilityRepository.createUnavailabilityEvent(
              userID, event);
        }

        _submissionState.add(RequestState.success(null));
        _navigate.add(const UnavailabilityFormNavigation.calendar());
      } catch (e, stacktrace) {
        logger.e(e, stackTrace: stacktrace);
        _submissionState.add(RequestState.exception(e));
      }
    }();
  }

  // Functions for updating text

  void updateStartDate(DateTime? date) {
    _selectedStartDate.add(date);
    checkFormValidity();
  }

  void updateEndDate(DateTime? date) {
    _selectedEndDate.add(date);
    checkFormValidity();
  }

  void updateStartTime(TimeOfDay? time) {
    _selectedStartTime.add(time);
    checkFormValidity();
  }

  void updateEndTime(TimeOfDay? time) {
    _selectedEndTime.add(time);
    checkFormValidity();
  }

  void updateEventTitle(String? value) {
    titleController.text = value ?? "";
    checkFormValidity();
  }

  @override
  Future<void> dispose() async {
    titleController.dispose();
    _selectedStartDate.close();
    _selectedStartTime.close();
    _selectedEndDate.close();
    _selectedEndTime.close();
    _navigate.close();
    _submissionState.close();
    _isFormValid.close();
  }
}
