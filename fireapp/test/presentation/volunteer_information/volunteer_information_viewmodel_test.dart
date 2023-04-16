import 'dart:io';

import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/volunteer_information_repository.dart';
import 'package:fireapp/domain/repository/volunteer_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/volunteer_information/volunteer_information_viewmodel.dart';
import 'package:fireapp/presentation/volunteer_list/volunteer_list_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:matcher/matcher.dart';

import '../../request_state_has_content_matcher.dart';
@GenerateNiceMocks([
  MockSpec<VolunteerInformationRepository>(),
])
import 'volunteer_information_viewmodel_test.mocks.dart';

void main() {
  const volunteers = <VolunteerListing>[
    VolunteerListing(
        volunteerId: "1",
        name: 'John Doe'
    ),
    VolunteerListing(
        volunteerId: "2",
        name: 'Jane Doe'
    )
  ];

  group('VolunteerListViewModel', ()
  {
    late VolunteerInformationRepository volunteerInformationRepository;
    late VolunteerInformationViewModel viewModel;

    final expectedQualifications = [
      Qualification(
        id: 1,
        name: 'Qualification 1',
        updated: DateTime.now(),
        created: DateTime.now(),
      ),
      Qualification(
        id: 2,
        name: 'Qualification 2',
        updated: DateTime.now(),
        created: DateTime.now(),
      )
    ];
    VolunteerInformation information = VolunteerInformation(
      ID: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'johndoe@example.com',
      mobileNo: '1234567890',
      prefHours: 10,
      expYears: 2,
      qualifications: expectedQualifications,
      availabilities: const AvailabilityField(
        monday: [[1, 8]],
        tuesday: [[]],
        wednesday: [[]],
        thursday: [[]],
        friday: [[]],
        saturday: [[]],
        sunday: [[]],
      ),
      possibleRoles: ['Role 1', 'Role 2'],
    );

    setUp(() {
      volunteerInformationRepository = MockVolunteerInformationRepository();
      viewModel = VolunteerInformationViewModel(volunteerInformationRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('get information of a volunteer', () {
      // Arrange
      when(volunteerInformationRepository.getVolunteerInformation("1"))
          .thenAnswer((_) async => information);

      // Assert
      expectLater(viewModel.volunteerInformation, emitsInOrder([
        emits(const TypeMatcher<
            InitialRequestState<VolunteerInformation>>()),
        emits(const TypeMatcher<
            LoadingRequestState<VolunteerInformation>>()),
        emits(RequestStateHasContentMatcher(information))
      ]));

      // Act
      viewModel.getVolunteerInformation("1");
      verify(volunteerInformationRepository.getVolunteerInformation("1"))
          .called(1);
    });
  });
}
