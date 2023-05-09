import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/repository/reference_data_repository.dart';
import 'package:fireapp/domain/repository/volunteer_information_repository.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/change_qualification/change_qualification_option_model.dart';
import 'package:fireapp/presentation/change_qualification/change_qualification_view_model.dart';
import 'package:fireapp/presentation/change_roles/change_roles_option_model.dart';
import 'package:fireapp/presentation/change_roles/change_roles_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import '../../request_state_has_content_matcher.dart';
@GenerateNiceMocks([
  MockSpec<ReferenceDataRepository>(),
  MockSpec<VolunteerInformationRepository>(),
])
import 'change_qualification_view_model_test.mocks.dart';

void main() {
  late MockReferenceDataRepository referenceDataRepository;
  late MockVolunteerInformationRepository volunteerInformationRepository;
  late ChangeQualificationsViewModel viewModel;

  setUp(() {
    referenceDataRepository = MockReferenceDataRepository();
    volunteerInformationRepository = MockVolunteerInformationRepository();
    viewModel = ChangeQualificationsViewModel(
      referenceDataRepository,
      volunteerInformationRepository
    );
  });

  group('load', () {
    test('should emit loading and then success when repository calls succeed', () async {
      final options = [
        Qualification(id: 1, name: "Qual", updated: DateTime.now(), created: DateTime.now()),
        Qualification(id: 2, name: "Qual2", updated: DateTime.now(), created: DateTime.now()),
      ];
      final userQualifications = [options[1]];

      final userData = UserQualifications(
        volunteerQualifications: options.map((e) => UserQualification(
            qualification: e, checked: userQualifications.contains(e)
        )).toList()
      );

      when(referenceDataRepository.getQualifications()).thenAnswer((_) async => options);

      final expectedOutput = [
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<SuccessRequestState<void>>()),
      ];

      expectLater(viewModel.userQualifications, emitsInOrder(expectedOutput));

      viewModel.init("1", userQualifications);
    });

    test('should emit loading and then exception when repository calls fail', () async {
      final exception = Exception('Failed to get dietary requirements');

      when(referenceDataRepository.getQualifications()).thenAnswer((_) => Future.error(exception));

      final expectedOutput = [
        emits(const TypeMatcher<InitialRequestState<void>>()),
        emits(const TypeMatcher<LoadingRequestState<void>>()),
        emits(const TypeMatcher<ExceptionRequestState<void>>()),
      ];

      expectLater(viewModel.userQualifications, emitsInOrder(expectedOutput));

      viewModel.load();
    });
  });

  group('updateRequirement', ()
  {
    test(
        'should emit success when updating a restriction is successful', () async {
      final options = [
        Qualification(id: 1,
            name: "Qual",
            updated: DateTime.now(),
            created: DateTime.now()),
        Qualification(id: 2,
            name: "Qual2",
            updated: DateTime.now(),
            created: DateTime.now()),
      ];
      final userQualifications = [options[1]];

      when(referenceDataRepository.getQualifications()).thenAnswer((
          _) async => options);

      // Assert
      expectLater(viewModel.submissionState, emitsInOrder([
        emits(const TypeMatcher<SuccessRequestState<void>>())
      ]));

      // Act
      viewModel.init("1", userQualifications);
      viewModel.submissionState.firstWhere((
          element) => element is SuccessRequestState).then((value) {
        viewModel.updateQualification(UserQualification(
            qualification: options[0],
            checked: true
        ));
        viewModel.submit();
      });
    });
  });
}