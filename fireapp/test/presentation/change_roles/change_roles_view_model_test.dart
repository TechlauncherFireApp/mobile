import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/domain/repository/volunteer_information_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/change_roles/change_roles_option_model.dart';
import 'package:fireapp/presentation/change_roles/change_roles_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import '../volunteer_information/volunteer_information_viewmodel_test.mocks.dart';
import 'change_roles_view_model_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ReferenceDataRepository>(),
  MockSpec<VolunteerInformationRepository>(),
])

void main() {
  late ChangeRolesViewModel viewModel;
  late MockReferenceDataRepository referenceDataRepository;
  late MockVolunteerInformationRepository volunteerInformationRepository;

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

    final submissionState = viewModel.submissionState as BehaviorSubject<
        RequestState<void>>;
    expect(submissionState.value, isA<SuccessRequestState<void>>());
  });
}

