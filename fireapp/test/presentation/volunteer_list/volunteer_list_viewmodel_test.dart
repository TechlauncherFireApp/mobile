import 'dart:io';

import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/volunteer_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/volunteer_list/volunteer_list_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:matcher/expect.dart' hide expectLater, expect;

import '../../request_state_has_content_matcher.dart';
@GenerateNiceMocks([
  MockSpec<VolunteerRepository>(),
])
import 'volunteer_list_viewmodel_test.mocks.dart';

void main() {
  const volunteers = <VolunteerListing>[
    VolunteerListing(
        volunteerId: "6",
        firstName: "John",
        lastName: "Testerson",
        qualification: ["test", "test"]
    ),
    VolunteerListing(
        volunteerId: "7",
        firstName: "test",
        lastName: "test",
        qualification: ["test", "test"]
    ),
  ];

  group('VolunteerListViewModel', () {
    late VolunteerRepository volunteerRepository;
    late VolunteerListViewModel viewModel;

    setUp(() {
      volunteerRepository = MockVolunteerRepository();
      viewModel = VolunteerListViewModel(volunteerRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('get list of volunteers', () {
      // Arrange
      when(volunteerRepository.volunteerList())
          .thenAnswer((_) async => volunteers);

      // Assert
      expectLater(viewModel.volunteers, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<List<VolunteerListing>>>()),
        emits(const TypeMatcher<LoadingRequestState<List<VolunteerListing>>>()),
        emits(RequestStateHasContentMatcher(volunteers))
      ]));

      // Act
      viewModel.getVolunteerList();
      verify(volunteerRepository.volunteerList()).called(1);
    });

    test('fail to get list of volunteers', () {
      final exception = Exception();
      // Arrange
      when(volunteerRepository.volunteerList())
          .thenThrow(exception);

      // Assert
      expectLater(viewModel.volunteers, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<List<VolunteerListing>>>()),
        emits(const TypeMatcher<LoadingRequestState<List<VolunteerListing>>>()),
        emits(RequestStateHasExceptionMatcher(exception))
      ]));

      // Act
      viewModel.getVolunteerList();
    });

    test('should return volunteer list with search term applied', () {
      final filtered = [volunteers[0]];
      // Arrange
      when(volunteerRepository.volunteerList())
          .thenAnswer((_) async => volunteers);

      // Assert
      expectLater(viewModel.volunteers, emitsInOrder([
        emits(const TypeMatcher<InitialRequestState<List<VolunteerListing>>>()),
        emits(const TypeMatcher<LoadingRequestState<List<VolunteerListing>>>()),
        emits(RequestStateHasContentMatcher(volunteers)),
        emits(RequestStateHasContentMatcher(filtered))
      ]));

      viewModel.volunteers.firstWhere((element) =>
        element is SuccessRequestState
      ).then((value) {
        viewModel.searchController.text = "John";
      });

      // Act
      viewModel.getVolunteerList();

      verify(volunteerRepository.volunteerList()).called(1);
    });
  });
}
