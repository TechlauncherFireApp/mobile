import 'dart:io';

import 'package:fireapp/domain/models/shift_request.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/repository/authentication_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fireapp/presentation/calendar/calendar_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:matcher/expect.dart' hide expectLater, expect;

import '../unavailability_form/unavailability_form_view_model_test.mocks.dart';
@GenerateNiceMocks([
  MockSpec<AuthenticationRepository>(),
])

void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;
  late MockUnavailabilityRepository mockUnavailabilityRepository;
  late CalendarViewModel viewModel;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockUnavailabilityRepository = MockUnavailabilityRepository();
    viewModel = CalendarViewModel(mockAuthenticationRepository, mockUnavailabilityRepository);
  });

  test('fetch unavailability events successfully', () async {
    // Mock session retrieval to always succeed
    when(mockAuthenticationRepository.getCurrentSession()).thenAnswer(
      (_) async => const TokenResponse(
          accessToken: 'test_token', userId: 1, role: "role"));

    // TODO add unavailability events to mockUnavailabilityRepository

    // Listen for the expected error state
    final List<RequestState<void>> emittedStates = [];
    final subscription = viewModel.loadingState.listen(emittedStates.add);

    // Attempt to submit the form
    viewModel.fetchUnavailabilityEvents();

    // Wait a bit for async logic to resolve and check for exceptions
    await Future.delayed(const Duration(seconds: 1));
    final containsSuccessState =
    emittedStates.any((state) => state is SuccessRequestState<void>);

    //Expect to contain the exception
    expectLater(containsSuccessState, true);
  });

  test('', () async {

  });

  test('Dispose closes all streams', () async {
    viewModel.dispose();
  });
}