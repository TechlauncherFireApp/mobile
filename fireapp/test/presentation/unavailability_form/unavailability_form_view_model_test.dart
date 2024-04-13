import 'dart:async';

import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/repository/unavailability_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/unavailability_form/unavailability_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
// Generate Mocks
@GenerateMocks([AuthenticationRepository, UnavailabilityRepository])
import 'unavailability_form_view_model_test.mocks.dart';

void main() {
  // Define the variables used across tests
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockUnavailabilityRepository mockUnavailabilityRepository;
  late UnavailabilityFormViewModel viewModel;

  // Set up function called before each test
  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockUnavailabilityRepository = MockUnavailabilityRepository();
    viewModel = UnavailabilityFormViewModel(
      mockAuthenticationRepository,
      mockUnavailabilityRepository,
    );
  });

  test('checkFormValidity should update isFormValidStream correctly', () async {
    final emissions = <bool>[];
    final Completer<void> completer = Completer();
    final subscription = viewModel.isFormValidStream.listen(
      (isValid) {
        emissions.add(isValid);
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    // Wait for the initial false emission
    await completer.future;

    // Simulate user input
    viewModel.updateEventTitle('Test Event');
    viewModel.updateStartDate(DateTime.now());
    viewModel.updateStartTime(TimeOfDay.now());
    viewModel.updateEndDate(DateTime.now().add(const Duration(days: 1)));
    viewModel.updateEndTime(TimeOfDay.now());

    // Allow time for async logic
    await Future.delayed(const Duration(milliseconds: 100));

    // Expectations
    expect(emissions.first, false); // Initially false
    expect(emissions.last, true); // Should be true after updates

    await subscription.cancel();
  });

  test('submitForm should change submissionState to loading then success',
      () async {
    when(mockAuthenticationRepository.getCurrentSession()).thenAnswer(
        (_) async => const TokenResponse(
            accessToken: 'test_token', userId: 1, role: "role"));
// Simulate user input
    viewModel.updateEventTitle('Test Event');
    viewModel.updateStartDate(DateTime.now());
    viewModel.updateStartTime(TimeOfDay.now());
    viewModel.updateEndDate(DateTime.now().add(const Duration(days: 1)));
    viewModel.updateEndTime(TimeOfDay.now());

    when(mockUnavailabilityRepository.createUnavailabilityEvent(any, any))
        .thenAnswer((_) async => {});

    expectLater(
        viewModel.submissionState,
        emitsInOrder([
          emits(const TypeMatcher<SuccessRequestState<void>>()),
          emits(const TypeMatcher<LoadingRequestState<void>>()),
          emits(const TypeMatcher<SuccessRequestState<void>>())
        ]));

    viewModel.submitForm();
  });

  test('submitForm should fail if end date is before start date', () async {
    // Mock session retrieval to always succeed
    when(mockAuthenticationRepository.getCurrentSession()).thenAnswer(
        (_) async => const TokenResponse(
            accessToken: 'test_token', userId: 1, role: "role"));

    viewModel.updateEventTitle('Test Event');
    // Setting start and end dates such that start is after end
    viewModel.updateStartDate(
        DateTime.now().add(const Duration(days: 1))); // Tomorrow
    viewModel.updateStartTime(TimeOfDay.now());
    viewModel.updateEndDate(DateTime.now()); // Today, so start is after end
    viewModel.updateEndTime(TimeOfDay.now());

    // Listen for the expected error state
    final List<RequestState<void>> emittedStates = [];
    final subscription = viewModel.submissionState.listen(emittedStates.add);

    // Attempt to submit the form
    viewModel.submitForm();

    // Wait a bit for async logic to resolve and check for exceptions
    await Future.delayed(const Duration(seconds: 1));
    final containsExceptionState =
    emittedStates.any((state) => state is ExceptionRequestState<void>);

    //Expect to contain the exception
    expectLater(containsExceptionState, true);

    await subscription.cancel(); // Clean up the stream subscription
  });

  test('updateStartTime updates selectedStartTime stream', () {
    final testDate = TimeOfDay.now();

    expectLater(viewModel.selectedStartTime, emits(testDate));

    viewModel.updateStartTime(testDate);
  });

  test('updateStartDate updates selectedStartDate stream', () {
    final testDate = DateTime.now();

    expectLater(viewModel.selectedStartDate, emits(testDate));

    viewModel.updateStartDate(testDate);
  });

  test('updateEndDate updates selectedEndDate stream', () {
    final testDate = DateTime.now();

    expectLater(viewModel.selectedEndDate, emits(testDate));

    viewModel.updateEndDate(testDate);
  });

  test('updateEndTime updates selectedEndTime stream', () {
    final testDate = TimeOfDay.now();

    expectLater(viewModel.selectedEndTime, emits(testDate));

    viewModel.updateEndTime(testDate);
  });

  test('updateEndTime updates selectedEndTime stream', () {
    const testTitle = "Event";

    viewModel.updateEventTitle(testTitle);

    expect(viewModel.titleController.text, testTitle);
  });

  test('Dispose closes all streams', () async {
    viewModel.dispose();
  });
}
