import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/domain/repository/volunteer_information_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/change_roles/change_roles_option_model.dart';
import 'package:fireapp/presentation/change_roles/change_roles_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'change_roles_view_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ReferenceDataRepository>(),
  MockSpec<VolunteerInformationRepository>(),
])

void main() {
  const volunteers = <VolunteerListing>[
    VolunteerListing(volunteerId: "1", name: 'John Doe'),
    VolunteerListing(volunteerId: "2", name: 'Jane Doe'),
  ];

  group('ChangeRolesViewModel', ()
  {
    late MockReferenceDataRepository referenceDataRepository;
    late MockVolunteerInformationRepository volunteerInformationRepository;
    late ChangeRolesViewModel viewModel;

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
      ),
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
      referenceDataRepository = MockReferenceDataRepository();
      volunteerInformationRepository = MockVolunteerInformationRepository();
      viewModel = ChangeRolesViewModel(
          referenceDataRepository, volunteerInformationRepository);
    });

    test('loads user roles successfully', () async {
      final roles = [
        VolunteerRole(id: 1,
            name: 'Role 1',
            created: DateTime.now(),
            updated: DateTime.now()),
        VolunteerRole(id: 2,
            name: 'Role 2',
            created: DateTime.now(),
            updated: DateTime.now()),
      ];

      when(referenceDataRepository.getRoles()).thenAnswer((_) async => roles);

      viewModel.init('volunteerId', ['2']);
      await Future.delayed(
          Duration(milliseconds: 100)); // Give time for async code to execute

      final userRolesState = viewModel.userRoles as BehaviorSubject<
          RequestState<List<UserRole>>>;
      expect(userRolesState.value, isA<SuccessRequestState<List<UserRole>>>());
      expect((userRolesState.value as SuccessRequestState).result, isNotEmpty);
    });

    test('updates a user role', () async {
      final roles = [
        VolunteerRole(id: 1,
            name: 'Role 1',
            created: DateTime.now(),
            updated: DateTime.now()),
        VolunteerRole(id: 2,
            name: 'Role 2',
            created: DateTime.now(),
            updated: DateTime.now()),
      ];

      when(referenceDataRepository.getRoles()).thenAnswer((_) async => roles);

      viewModel.init('volunteerId', ['2']);
      await Future.delayed(
          Duration(milliseconds: 100)); // Give time for async code to execute

      final userRolesState = viewModel.userRoles as BehaviorSubject<
          RequestState<List<UserRole>>>;
      final userRole = (userRolesState.value as SuccessRequestState<
          List<UserRole>>).result[0];

      viewModel.updateRole(userRole);
      await Future.delayed(
          Duration(milliseconds: 100)); // Give time for async code to execute

      expect(userRolesState.value, isA<SuccessRequestState<List<UserRole>>>());
      expect((userRolesState.value as SuccessRequestState).result[0].checked,
          !userRole.checked);
    });

    test('submits user roles successfully', () async {
      final roles = [
        VolunteerRole(id: 1,
            name: 'Role 1',
            created: DateTime.now(),
            updated: DateTime.now()),
        VolunteerRole(id: 2,
            name: 'Role 2',
            created: DateTime.now(),
            updated: DateTime.now()),
      ];

      when(referenceDataRepository.getRoles()).thenAnswer((_) async => roles);

      expectLater(viewModel.submissionState, emitsInOrder([
        emits(const TypeMatcher<SuccessRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<SuccessRequestState<void>>())
      ]));

      viewModel.init('volunteerId', ['2']);
      await Future.delayed(
          Duration(milliseconds: 100)); // Give time for async code to execute

      viewModel.submit();
      await Future.delayed(
          Duration(milliseconds: 100)); // Give time for async code to execute

      final userRolesState = viewModel.userRoles as BehaviorSubject<
          RequestState<List<UserRole>>>;
      final selectedRoles = (userRolesState.value as SuccessRequestState<
          List<UserRole>>)
          .result
          .where((r) => r.checked)
          .map((r) => r.role)
          .toList();

      verify(volunteerInformationRepository.updateRoles(selectedRoles)).called(1);
    });
  });
}

